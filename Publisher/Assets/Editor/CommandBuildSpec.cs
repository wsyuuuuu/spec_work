using System;
using System.IO;
using UnityEditor;
using UnityEngine;
using YooAsset.Editor;
using System.Collections.Generic;
using System.Reflection;

public class CommandBuildSpec
{
    #region CommandLineArg
    private static Dictionary<string, string> _commandLineArgs;

    private static string InternalGetCommandLineArg(string key, bool throwExceptionNotFound)
    {
        if (_commandLineArgs == null)
        {
            _commandLineArgs = new Dictionary<string, string>();
            var commandLineArgs = Environment.GetCommandLineArgs();
            foreach (var commandLineArg in commandLineArgs)
            {
                var split = commandLineArg.Split('=');
                if (split.Length == 2)
                {
                    _commandLineArgs.Add(split[0], split[1]);
                }
            }
        }
        _commandLineArgs.TryGetValue(key, out string value);
        if (throwExceptionNotFound && value == null)
        {
            throw new Exception("Command line arg not found: " + key);
        }
        return value;
    }

    public static string GetCommandLineArg(string key)
    {
        return InternalGetCommandLineArg(key, true);
    }

    public static bool GetCommandLineBool(string key)
    {
        string value = InternalGetCommandLineArg(key, true);
        return value.Equals("true");
    }

    public static int GetCommandLineInt(string key)
    {
        string value = InternalGetCommandLineArg(key, true);
        return int.TryParse(value, out int result) ? result : throw new Exception("Command line arg parse int failed: " + key);
    }
    #endregion

    private const string kPackageName = "SpecPackage";
    public static void Build()
    {
        string outputRoot;
        int specVersion;
        if (Application.isBatchMode)
        {
            outputRoot = GetCommandLineArg("BundleOutputRoot");
            specVersion = GetCommandLineInt("SpecVersion");
        }
        else
        {
            outputRoot = "Bundles";
            specVersion = 0;
        }

        string outputPath = BuildSpec(outputRoot, specVersion);

        UploadSpec(outputPath, specVersion);
    }

    private static string BuildSpec(string outputRoot, int specVersion)
    {
        Debug.Log("================▶️ 构建配置包================");
        string outputPath = $"{outputRoot}/{kPackageName}/{specVersion}";
        if (Directory.Exists(outputPath))
        {
            Debug.LogFormat("检查到已存在Bundle对应目标到输出路径，删除输出路径={0}", outputPath);
            Directory.Delete(outputPath, true);
        }

        BuildParameters buildParameters = new BuildParameters
        {
            BuildOutputRoot = outputRoot,
            BuildTarget = EditorUserBuildSettings.activeBuildTarget,
            BuildPipeline = EBuildPipeline.ScriptableBuildPipeline,
            BuildMode = EBuildMode.IncrementalBuild,
            PackageName = kPackageName,
            PackageVersion = specVersion.ToString(),
            VerifyBuildingResult = true,
            SharedPackRule = new ZeroRedundancySharedPackRule(),
            EncryptionServices = null,
            CompressOption = ECompressOption.LZ4,
            OutputNameStyle = EOutputNameStyle.HashName,
            CopyBuildinFileOption = ECopyBuildinFileOption.None,

            SBPParameters = new BuildParameters.SBPBuildParameters
            {
                WriteLinkXML = false
            }
        };

        var builder = new AssetBundleBuilder();
        var buildResult = builder.Run(buildParameters);
        if (!buildResult.Success)
        {
            Debug.LogFormat("BuildResult.FailedTask={0}", buildResult.FailedTask);
            throw new Exception(buildResult.ErrorInfo);
        }

        Debug.Log("================✅ 构建配置包================");
        return outputPath;
    }

    private static void UploadSpec(string outputPath, int specVersion)
    {
        Debug.Log("================▶️ 上传补丁================");
        string rootPath = GetCommandLineArg("LocalWebServerRoot");
        string packagePath = $"{rootPath}/{kPackageName}";
        if (!Directory.Exists(packagePath))
        {
            Directory.CreateDirectory(packagePath);
        }
        Debug.LogFormat("Copy AssetBundle to local storage path: {0}", packagePath);
        foreach (var fileFullPath in Directory.GetFiles(outputPath))
        {
            var fileName = Path.GetFileName(fileFullPath);
            File.Copy(fileFullPath, $"{packagePath}/{fileName}", true);
        }
        Debug.Log("================✅ 上传补丁================");
    }
}