function InstallVS
{
  Param
  (
    [String] $WorkLoads,
    [String] $Sku,
    [String] $VSBootstrapperURL,
    [String] $VSInstallLocation
  )

  $exitCode = -1

  if ([String]::IsNullOrEmpty($VSInstallLocation))
  {
    Write-Host -Object "InstallLocation was null or empty : $exitCode."
    exit $exitCode
  }

  try
  {
    Write-Host "Downloading Visual Studio 2017 $Sku Installer ..."
    Invoke-WebRequest -Uri $VSBootstrapperURL -OutFile "${env:Temp}\vs_$Sku.exe"

    $FilePath = "${env:Temp}\vs_$Sku.exe"
    $Arguments = ("/c", "`"`"$FilePath`" --installPath `"$VSInstallLocation`" $WorkLoads  --quiet --norestart --wait --nocache`"" )

    Write-Host "Starting Install ..."
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
    $exitCode = $process.ExitCode
    
    if ($exitCode -eq 0 -or $exitCode -eq 3010)
    {
      Write-Host -Object "Installation successful"
      return $exitCode
    }
    else
    {
      Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."

      # this wont work because of log size limitation in extension manager
      # Get-Content $customLogFilePath | Write-Host

      exit $exitCode
    }
  }
  catch
  {
    Write-Host -Object "Failed to install Visual Studio. Check the logs for details in $customLogFilePath"
    Write-Host -Object $_.Exception.Message
    exit -1
  }
}

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.CoreEditor
#   Visual Studio のコア エディター
#   構文認識コード編集機能、ソース コード管理、作業項目管理などの Visual Studio の基本的なシェル エクスペリエンス。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.CoreEditor '                                       # [Workload] Microsoft.VisualStudio.Workload.CoreEditor
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CoreEditor '                                 # [必須] Visual Studio のコア エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.StartPageExperiment.Cpp '                    # [任意] C++ ユーザー用 Visual Studio スタート ページ

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Azure
#   Azure の開発
#   クラウド アプリの開発、リソースの作成、Docker サポートを含むコンテナーのビルドのための Azure SDK、ツール、プロジェクト。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Azure '                                            # [Workload] Microsoft.VisualStudio.Workload.Azure
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                         # [必須] Microsoft Azure WebJobs ツール
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                      # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [必須] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [必須] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Component.NetFX.Core.Runtime '                                      # [必須] .NET Core ランタイム
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                 # [必須] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [必須] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [必須] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools.2.1 '                       # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.Web.2.1 '                                    # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                       # [必須] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                           # [必須] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                     # [必須] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                     # [必須] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                              # [必須] Cloud Explorer
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                                # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools.BuildTools '                     # [必須] コンテナーの開発ツール - Build Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                     # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                        # [必須] Web プロジェクト用の F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                   # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CMDUtils '                               # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.NCLI '                                   # [必須] SQL Server Native Client
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [必須] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [必須] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                        # [必須] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Azure.Prerequisites '                   # [必須] Azure 開発の前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                        # [必須] Microsoft Azure WebJobs ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.Component.Azure.DataLake.Tools '                                    # [推奨] Azure Data Lake と Stream Analytics ツール
$WorkLoads +=     '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                   # [推奨] .NET Framework 4.5.1 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                     # [推奨] .NET Framework 4.6 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                       # [推奨] .NET Framework 4 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                            # [推奨] .NET Framework 4 – 4.6 開発ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.AspNet45 '                                     # [推奨] 高度な ASP.NET 機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.MobileAppsSdk '                        # [推奨] Azure Mobile Apps SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ResourceManager.Tools '                # [推奨] Azure Resource Manager コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ServiceFabric.Tools '                  # [推奨] Service Fabric Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton '                             # [推奨] Azure Cloud Services コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools '                  # [推奨] Azure Cloud Services ビルド ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                              # [推奨] .NET プロファイル ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                    # [推奨] Web 配置
$WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Azure.CloudServices '                     # [推奨] Azure Cloud Services ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Azure.ResourceManager.Tools '             # [推奨] Azure Resource Manager ツール
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.SDK '                                             # [任意] .NET Framework 4.6.2 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                   # [任意] .NET Framework 4.6.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.SDK '                                             # [任意] .NET Framework 4.7.1 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                   # [任意] .NET Framework 4.7.1 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.SDK '                                             # [任意] .NET Framework 4.7.2 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                   # [任意] .NET Framework 4.7.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.SDK '                                               # [任意] .NET Framework 4.7 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.TargetingPack '                                     # [任意] .NET Framework 4.7 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                             # [任意] .NET Framework 4.6.2 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                             # [任意] .NET Framework 4.7.1 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.2.DeveloperTools '                             # [任意] .NET Framework 4.7.2 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                               # [任意] .NET Framework 4.7 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK '                                            # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.1x '                                         # [任意] .NET Core 1.0 - 1.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.1x.ComponentGroup.Web '                                     # [任意] .NET Core 1.0 - 1.1 Web 用開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools '                           # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.Web '                                        # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.AzCopy '                       # [任意] Azure Storage AzCopy
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [任意] Windows Communication Foundation

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Data
#   データ ストレージとデータ処理
#   SQL Server、Azure Data Lake、Hadoop を使用してデータ ソリューションの接続、開発、テストを行います。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Data '                                           # [Workload] Microsoft.VisualStudio.Workload.Data
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [推奨] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                      # [推奨] ライブラリ マネージャー
# $WorkLoads +=     '--add Component.Redgate.SQLSearch.VSExtension '                                     # [推奨] Redgate SQL Search
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [推奨] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.Component.Azure.DataLake.Tools '                                    # [推奨] Azure Data Lake と Stream Analytics ツール
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [推奨] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [推奨] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                 # [推奨] .NET Framework 4.5.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                 # [推奨] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [推奨] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [推奨] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [推奨] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                   # [推奨] .NET Framework 4.6 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                     # [推奨] .NET Framework 4 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [推奨] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                          # [推奨] .NET Framework 4 – 4.6 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [推奨] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                       # [推奨] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                           # [推奨] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                     # [推奨] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                     # [推奨] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton '                             # [推奨] Azure Cloud Services コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools '                  # [推奨] Azure Cloud Services ビルド ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                              # [推奨] Cloud Explorer
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [推奨] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                                # [推奨] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools.BuildTools '                     # [推奨] コンテナーの開発ツール - Build Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [推奨] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [推奨] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [推奨] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [推奨] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [推奨] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [推奨] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [推奨] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [推奨] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                   # [推奨] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [推奨] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CMDUtils '                               # [推奨] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [推奨] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [推奨] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.NCLI '                                   # [推奨] SQL Server Native Client
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [推奨] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [推奨] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [推奨] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [推奨] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [推奨] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                        # [推奨] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [推奨] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                             # [任意] F# デスクトップ言語のサポート

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.DataScience
#   データ サイエンスと分析のアプリケーション
#   データ サイエンス アプリケーションを作成するための言語とツール (Python、R、F# が含まれます)。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.DataScience '                                    # [Workload] Microsoft.VisualStudio.Workload.DataScience
# $WorkLoads +=     '--add Component.Anaconda3.x64 '                                                     # [推奨] Anaconda3 64 ビット (5.2.0)
# $WorkLoads +=     '--add Microsoft.Component.CookiecutterTools '                                       # [推奨] cookiecutter テンプレートのサポート
# $WorkLoads +=     '--add Microsoft.Component.PythonTools '                                             # [推奨] Python 言語サポート
# $WorkLoads +=     '--add Microsoft.Component.PythonTools.Web '                                         # [推奨] Python Web サポート
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [推奨] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [推奨] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                             # [推奨] F# デスクトップ言語のサポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [推奨] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [推奨] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.R.Open '                                     # [推奨] Microsoft R クライアント (3.3.2)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.RHost '                                      # [推奨] R 開発ツールのランタイム サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [推奨] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [推奨] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.RTools '                                     # [推奨] R 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [推奨] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [推奨] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [推奨] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [推奨] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.Anaconda2.x64 '                                                     # [任意] Anaconda2 64 ビット (5.2.0)
# $WorkLoads +=     '--add Component.Anaconda2.x86 '                                                     # [任意] Anaconda2 32 ビット (5.2.0)
# $WorkLoads +=     '--add Component.Anaconda3.x86 '                                                     # [任意] Anaconda3 32 ビット (5.2.0)
# $WorkLoads +=     '--add Microsoft.Component.VC.Runtime.UCRTSDK '                                      # [任意] Windows Universal CRT SDK
# $WorkLoads +=     '--add Microsoft.ComponentGroup.PythonTools.NativeDevelopment '                      # [任意] Python ネイティブ開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [任意] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Win81 '                             # [任意] グラフィックス ツール Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.140 '                                     # [任意] デスクトップ用 VC++ 2015.3 v14.00 (v140) ツールセット
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [任意] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                         # [任意] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [任意] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK '                               # [任意] Windows ユニバーサル C ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [任意] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows81SDK '                               # [任意] Windows 8.1 SDK

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.ManagedDesktop
#   .NET デスクトップ開発
#   C#、Visual Basic、F# を使用して、WPF、Windows フォーム、コンソール アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.ManagedDesktop '                                   # [Workload] Microsoft.VisualStudio.Workload.ManagedDesktop
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [必須] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [必須] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [必須] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Prerequisites '               # [必須] .NET デスクトップ開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [必須] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.ComponentGroup.Blend '                                              # [推奨] Blend for Visual Studio
$WorkLoads +=     '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                 # [推奨] .NET Framework 4.5.1 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                 # [推奨] .NET Framework 4.5.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [推奨] .NET Framework 4.5 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                   # [推奨] .NET Framework 4.6 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                     # [推奨] .NET Framework 4 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                          # [推奨] .NET Framework 4 – 4.6 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Debugger.JustInTime '                        # [推奨] Just-In-Time デバッガー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.EntityFramework '                            # [推奨] Entity Framework 6 Tools
# $WorkLoads +=     '--add Component.Dotfuscator '                                                       # [任意] PreEmptive Protection - Dotfuscator
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [任意] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                      # [任意] ライブラリ マネージャー
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [任意] WebSocket4Net
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.SDK '                                           # [任意] .NET Framework 4.6.2 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                 # [任意] .NET Framework 4.6.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.SDK '                                           # [任意] .NET Framework 4.7.1 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [任意] .NET Framework 4.7.1 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.SDK '                                           # [任意] .NET Framework 4.7.2 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [任意] .NET Framework 4.7.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.SDK '                                             # [任意] .NET Framework 4.7 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.TargetingPack '                                   # [任意] .NET Framework 4.7 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                           # [任意] .NET Framework 4.6.2 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                           # [任意] .NET Framework 4.7.1 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.2.DeveloperTools '                           # [任意] .NET Framework 4.7.2 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                             # [任意] .NET Framework 4.7 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK '                                            # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.1x '                                         # [任意] .NET Core 1.0 - 1.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [任意] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools '                           # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools.2.1 '                       # [任意] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [任意] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                                # [任意] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools.BuildTools '                     # [任意] コンテナーの開発ツール - Build Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                     # [任意] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                             # [任意] F# デスクトップ言語のサポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [任意] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [任意] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [任意] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [任意] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                   # [任意] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CMDUtils '                               # [任意] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [任意] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [任意] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.NCLI '                                   # [任意] SQL Server Native Client
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [任意] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [任意] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [任意] Windows Communication Foundation
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                        # [任意] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [任意] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [任意] ASP.NET と Web 開発

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.ManagedGame
#   Unity でのゲーム開発
#   強力なクロスプラットフォーム開発環境である Unity を使って、2D および 3D ゲームを作成します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.ManagedGame '                                    # [Workload] Microsoft.VisualStudio.Workload.ManagedGame
# $WorkLoads +=     '--add Microsoft.Net.Component.3.5.DeveloperTools '                                  # [必須] .NET Framework 3.5 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [必須] .NET Framework 4.7.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Unity '                                      # [必須] Visual Studio Tools for Unity
# $WorkLoads +=     '--add Component.UnityEngine.x64 '                                                   # [推奨] Unity 2018.3 64 ビット エディター
# $WorkLoads +=     '--add Component.UnityEngine.x86 '                                                   # [推奨] Unity 5.6 32 ビット エディター

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeCrossPlat
#   C++ による Linux 開発
#   Linux 環境で実行するアプリケーションを作成およびデバッグします。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NativeCrossPlat '                                # [Workload] Microsoft.VisualStudio.Workload.NativeCrossPlat
# $WorkLoads +=     '--add Component.MDD.Linux '                                                         # [必須] Visual C++ for Linux Development
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [必須] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK '                               # [必須] Windows ユニバーサル C ランタイム
# $WorkLoads +=     '--add Component.Linux.CMake '                                                       # [推奨] CMake および Linux 用 Visual C++ ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [推奨] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [推奨] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [推奨] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.MDD.Linux.GCC.arm '                                                 # [任意] Embedded 開発と IoT 開発

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeDesktop
#   C++ によるデスクトップ開発
#   Microsoft C++ ツールセット、ATL、MFC を使用して Windows のデスクトップ アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NativeDesktop '                                  # [Workload] Microsoft.VisualStudio.Workload.NativeDesktop
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [必須] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Redist.14.Latest '                        # [必須] Visual C++ 2017 再頒布可能パッケージ Update
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core '                    # [必須] Visual C++ コア デスクトップ機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Debugger.JustInTime '                        # [推奨] Just-In-Time デバッガー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [推奨] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Win81 '                             # [推奨] グラフィックス ツール Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [推奨] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [推奨] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL '                                     # [推奨] x86 用と x64 用の Visual C++ ATL
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CMake.Project '                           # [推奨] CMake の Visual C++ ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                         # [推奨] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.TestAdapterForBoostTest '                 # [推奨] Test Adapter for Boost.Test
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.TestAdapterForGoogleTest '                # [推奨] Test Adapter for Google Test
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [推奨] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [推奨] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.Incredibuild '                                                      # [任意] IncrediBuild - ビルド アクセラレーション
# $WorkLoads +=     '--add Component.IncredibuildMenu '                                                  # [任意] IncrediBuildMenu
# $WorkLoads +=     '--add Microsoft.Component.VC.Runtime.UCRTSDK '                                      # [任意] Windows Universal CRT SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [任意] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [任意] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.140 '                                     # [任意] デスクトップ用 VC++ 2015.3 v14.00 (v140) ツールセット
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATLMFC '                                  # [任意] x86 用と x64 用の Visual C++ MFC
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CLI.Support '                             # [任意] C++/CLI サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 '                         # [任意] 標準ライブラリ用モジュール (試験段階)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.10240 '                         # [任意] Windows 10 SDK (10.0.10240.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.10586 '                         # [任意] Windows 10 SDK (10.0.10586.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.14393 '                         # [任意] Windows 10 SDK (10.0.14393.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.Desktop '                 # [任意] デスクトップ用 Windows 10 SDK (10.0.15063.0) C++ [x86 および x64]
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP '                     # [任意] UWP 用 Windows 10 SDK (10.0.15063.0):C#、VB、JS
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP.Native '              # [任意] UWP 用 Windows 10 SDK (10.0.15063.0):C++
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop '                 # [任意] デスクトップ用 Windows 10 SDK (10.0.16299.0) C++ [x86 および x64]
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop.arm '             # [任意] デスクトップ用 Windows 10 SDK (10.0.16299.0) C++ [ARM および ARM64]
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.UWP '                     # [任意] UWP 用 Windows 10 SDK (10.0.16299.0):C#、VB、JS
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.UWP.Native '              # [任意] UWP 用 Windows 10 SDK (10.0.16299.0):C++
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17134 '                         # [任意] Windows 10 SDK (10.0.17134.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows81SDK '                               # [任意] Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WinXP '                                      # [任意] C++ に関する Windows XP サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Win81 '                   # [任意] Windows 8.1 SDK と UCRT SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.WinXP '                   # [任意] C++ に関する Windows XP サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Windows10SDK.15063 '                    # [任意] Windows 10 SDK (10.0.15063.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Windows10SDK.16299 '                    # [任意] Windows 10 SDK (10.0.16299.0)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeGame
#   C++ によるゲーム開発
#   C++ を最大限に活用して、DirectX、Unreal、Cocos2d を利用するプロフェッショナルなゲームを構築します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NativeGame '                                     # [Workload] Microsoft.VisualStudio.Workload.NativeGame
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [必須] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Redist.14.Latest '                        # [必須] Visual C++ 2017 再頒布可能パッケージ Update
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [必須] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK '                               # [必須] Windows ユニバーサル C ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [推奨] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Win81 '                             # [推奨] グラフィックス ツール Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                         # [推奨] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [推奨] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Component.Android.NDK.R12B '                                                  # [任意] Android NDK (R12B)
# $WorkLoads +=     '--add Component.Android.SDK23.Private '                                             # [任意] Android SDK セットアップ (API レベル 23) (JavaScript/C++ を使用したモバイル開発のためにローカルにインストール
# $WorkLoads +=     '--add Component.Ant '                                                               # [任意] Apache Ant (1.9.3)
# $WorkLoads +=     '--add Component.Cocos '                                                             # [任意] Cocos
# $WorkLoads +=     '--add Component.Incredibuild '                                                      # [任意] IncrediBuild - ビルド アクセラレーション
# $WorkLoads +=     '--add Component.IncredibuildMenu '                                                  # [任意] IncrediBuildMenu
# $WorkLoads +=     '--add Component.MDD.Android '                                                       # [任意] C++ Android 開発ツール
# $WorkLoads +=     '--add Component.OpenJDK '                                                           # [任意] Microsoft 配布の OpenJDK
# $WorkLoads +=     '--add Component.Unreal '                                                            # [任意] Unreal Engine のインストーラー
# $WorkLoads +=     '--add Component.Unreal.Android '                                                    # [任意] Unreal Engine 用の Visual Studio Android サポート
# $WorkLoads +=     '--add Microsoft.Component.VC.Runtime.UCRTSDK '                                      # [任意] Windows Universal CRT SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                 # [任意] .NET Framework 4.5.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                 # [任意] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [任意] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [任意] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [任意] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                   # [任意] .NET Framework 4.6 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                     # [任意] .NET Framework 4 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [任意] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                          # [任意] .NET Framework 4 – 4.6 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet.BuildTools '                           # [任意] NuGet ターゲットとビルド タスク
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [任意] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [任意] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.10240 '                         # [任意] Windows 10 SDK (10.0.10240.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.10586 '                         # [任意] Windows 10 SDK (10.0.10586.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.14393 '                         # [任意] Windows 10 SDK (10.0.14393.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.Desktop '                 # [任意] デスクトップ用 Windows 10 SDK (10.0.15063.0) C++ [x86 および x64]
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP '                     # [任意] UWP 用 Windows 10 SDK (10.0.15063.0):C#、VB、JS
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP.Native '              # [任意] UWP 用 Windows 10 SDK (10.0.15063.0):C++
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop '                 # [任意] デスクトップ用 Windows 10 SDK (10.0.16299.0) C++ [x86 および x64]
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop.arm '             # [任意] デスクトップ用 Windows 10 SDK (10.0.16299.0) C++ [ARM および ARM64]
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.UWP '                     # [任意] UWP 用 Windows 10 SDK (10.0.16299.0):C#、VB、JS
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.UWP.Native '              # [任意] UWP 用 Windows 10 SDK (10.0.16299.0):C++
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17134 '                         # [任意] Windows 10 SDK (10.0.17134.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows81SDK '                               # [任意] Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Win81 '                   # [任意] Windows 8.1 SDK と UCRT SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Windows10SDK.15063 '                    # [任意] Windows 10 SDK (10.0.15063.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Windows10SDK.16299 '                    # [任意] Windows 10 SDK (10.0.16299.0)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeMobile
#   C++ でのモバイル開発
#   iOS、Android、Windows 向けのクロスプラットフォーム アプリケーションを、C++ を使って構築します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NativeMobile '                                   # [Workload] Microsoft.VisualStudio.Workload.NativeMobile
# $WorkLoads +=     '--add Component.Android.SDK19.Private '                                             # [必須] Android SDK セットアップ (API レベル 19) (Javascript/C++ を使用したモバイル開発のためにローカルにインストール
# $WorkLoads +=     '--add Component.Android.SDK21.Private '                                             # [必須] Android SDK セットアップ (API レベル 21) (Javascript/C++ を使用したモバイル開発のためにローカルにインストール
# $WorkLoads +=     '--add Component.Android.SDK22.Private '                                             # [必須] Android SDK セットアップ (API レベル 22) (Javascript/C++ を使用したモバイル開発のためにローカルにインストール
# $WorkLoads +=     '--add Component.Android.SDK23.Private '                                             # [必須] Android SDK セットアップ (API レベル 23) (JavaScript/C++ を使用したモバイル開発のためにローカルにインストール
# $WorkLoads +=     '--add Component.Android.SDK25.Private '                                             # [必須] Android SDK セットアップ (API レベル 25) (Javascript/C++ を使用したモバイル開発のためにローカルにインストール
# $WorkLoads +=     '--add Component.OpenJDK '                                                           # [必須] Microsoft 配布の OpenJDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [必須] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Component.Android.NDK.R15C '                                                  # [推奨] Android NDK (R15C)
# $WorkLoads +=     '--add Component.Ant '                                                               # [推奨] Apache Ant (1.9.3)
# $WorkLoads +=     '--add Component.MDD.Android '                                                       # [推奨] C++ Android 開発ツール
# $WorkLoads +=     '--add Component.Android.NDK.R12B '                                                  # [任意] Android NDK (R12B)
# $WorkLoads +=     '--add Component.Android.NDK.R12B_3264 '                                             # [任意] Android NDK (R12B) (32 ビット)
# $WorkLoads +=     '--add Component.Android.NDK.R13B '                                                  # [任意] Android NDK (R13B)
# $WorkLoads +=     '--add Component.Android.NDK.R13B_3264 '                                             # [任意] Android NDK (R13B) (32 ビット)
# $WorkLoads +=     '--add Component.Android.NDK.R15C_3264 '                                             # [任意] Android NDK (R15C) (32 ビット)
# $WorkLoads +=     '--add Component.Google.Android.Emulator.API23.Private '                             # [任意] Google Android Emulator (API レベル 23) (ローカル インストール)
# $WorkLoads +=     '--add Component.HAXM.Private '                                                      # [任意] Intel Hardware Accelerated Execution Manager (HAXM) (ローカル インストール)
# $WorkLoads +=     '--add Component.Incredibuild '                                                      # [任意] IncrediBuild - ビルド アクセラレーション
# $WorkLoads +=     '--add Component.IncredibuildMenu '                                                  # [任意] IncrediBuildMenu
# $WorkLoads +=     '--add Component.MDD.IOS '                                                           # [任意] C++ iOS 開発ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NetCoreTools
#   .NET Core クロスプラットフォームの開発
#   .NET Core、ASP.NET Core、HTML/JavaScript、コンテナー (Docker サポートなど) を使用して、クロスプラットフォーム アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NetCoreTools '                                     # [Workload] Microsoft.VisualStudio.Workload.NetCoreTools
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                      # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [必須] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [必須] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                 # [必須] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [必須] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [必須] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools.2.1 '                       # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.Web.2.1 '                                    # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                                # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools.BuildTools '                     # [必須] コンテナーの開発ツール - Build Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                     # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                        # [必須] Web プロジェクト用の F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                   # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CMDUtils '                               # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.NCLI '                                   # [必須] SQL Server Native Client
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [必須] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [必須] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                         # [推奨] Microsoft Azure WebJobs ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [推奨] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                       # [推奨] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                           # [推奨] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                     # [推奨] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                     # [推奨] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                              # [推奨] Cloud Explorer
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [推奨] .NET プロファイル ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                        # [推奨] ASP.NET と Web の開発ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                        # [推奨] Microsoft Azure WebJobs ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web.CloudTools '                        # [推奨] Web 開発用クラウド ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK '                                            # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.1x '                                         # [任意] .NET Core 1.0 - 1.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.1x.ComponentGroup.Web '                                     # [任意] .NET Core 1.0 - 1.1 Web 用開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools '                           # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.Web '                                        # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.IISDevelopment '                        # [任意] 開発時の IIS サポート

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NetCrossPlat
#   .NET によるモバイル開発
#   iOS、Android、Windows 向けのクロスプラットフォーム アプリケーションを、Xamarin を使って構築します。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NetCrossPlat '                                     # [Workload] Microsoft.VisualStudio.Workload.NetCrossPlat
# $WorkLoads +=     '--add Component.Xamarin '                                                           # [必須] Xamarin
# $WorkLoads +=     '--add Component.Xamarin.RemotedSimulator '                                          # [必須] Xamarin Remoted Simulator
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [必須] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [必須] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK '                                            # [必須] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools '                           # [必須] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                     # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Merq '                                       # [必須] Xamarin の一般的な内部ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MonoDebugger '                               # [必須] Mono デバッガー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions.TemplateEngine '     # [必須] ASP.NET テンプレート エンジン
# $WorkLoads +=     '--add Component.Android.SDK27 '                                                     # [推奨] Android SDK セットアップ (API レベル 27)
# $WorkLoads +=     '--add Component.Google.Android.Emulator.API27 '                                     # [推奨] Google Android Emulator (API レベル 27)
# $WorkLoads +=     '--add Component.HAXM '                                                              # [推奨] Intel Hardware Accelerated Execution Manager (HAXM) (グローバル インストール)
# $WorkLoads +=     '--add Component.OpenJDK '                                                           # [推奨] Microsoft 配布の OpenJDK
# $WorkLoads +=     '--add Component.Xamarin.Inspector '                                                 # [任意] Xamarin Workbooks
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [任意] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.NetFX.Native '                                            # [任意] .NET Native
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [任意] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [任意] .NET プロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics '                                   # [任意] イメージ エディターと 3D モデル エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [任意] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [任意] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [任意] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.Xamarin '                           # [任意] Xamarin 用ユニバーサル Windows プラットフォーム ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NetWeb
#   ASP.NET と Web 開発
#   ASP.NET、ASP.NET Core、HTML/JavaScript、コンテナー (Docker サポートなど) を使用して、Web アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NetWeb '                                           # [Workload] Microsoft.VisualStudio.Workload.NetWeb
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                      # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [必須] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [必須] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
$WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                   # [必須] .NET Framework 4.5.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                     # [必須] .NET Framework 4.5 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                             # [必須] .NET Framework 4.6.1 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                   # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [必須] .NET Framework 4.6.1 開発ツール
$WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools.2.1 '                       # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.Web.2.1 '                                    # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                                # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools.BuildTools '                     # [必須] コンテナーの開発ツール - Build Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                     # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                        # [必須] Web プロジェクト用の F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                   # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CMDUtils '                               # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.NCLI '                                   # [必須] SQL Server Native Client
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [必須] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [必須] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                        # [必須] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                         # [推奨] Microsoft Azure WebJobs ツール
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                 # [推奨] .NET Framework 4.5.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                   # [推奨] .NET Framework 4.6 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                     # [推奨] .NET Framework 4 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                            # [推奨] .NET Framework 4 – 4.6 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [推奨] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AspNet45 '                                   # [推奨] 高度な ASP.NET 機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                       # [推奨] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                           # [推奨] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                     # [推奨] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                     # [推奨] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                              # [推奨] Cloud Explorer
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                              # [推奨] .NET プロファイル ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.EntityFramework '                              # [推奨] Entity Framework 6 Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [推奨] Windows Communication Foundation
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                    # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                        # [推奨] Microsoft Azure WebJobs ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web.CloudTools '                          # [推奨] Web 開発用クラウド ツール
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.SDK '                                             # [任意] .NET Framework 4.6.2 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                   # [任意] .NET Framework 4.6.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.SDK '                                             # [任意] .NET Framework 4.7.1 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                   # [任意] .NET Framework 4.7.1 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.SDK '                                             # [任意] .NET Framework 4.7.2 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                   # [任意] .NET Framework 4.7.2 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.SDK '                                               # [任意] .NET Framework 4.7 SDK
$WorkLoads +=     '--add Microsoft.Net.Component.4.7.TargetingPack '                                     # [任意] .NET Framework 4.7 Targeting Pack
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                             # [任意] .NET Framework 4.6.2 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                             # [任意] .NET Framework 4.7.1 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.2.DeveloperTools '                             # [任意] .NET Framework 4.7.2 開発ツール
$WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                               # [任意] .NET Framework 4.7 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK '                                            # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.1x '                                         # [任意] .NET Core 1.0 - 1.1 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.1x.ComponentGroup.Web '                                     # [任意] .NET Core 1.0 - 1.1 Web 用開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools '                           # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.Web '                                        # [任意] .NET Core 2.0 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.IISDevelopment '                        # [任意] 開発時の IIS サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Web.Mvc4.ComponentGroup '                              # [任意] ASP.NET MVC 4

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Node
#   Node.js 開発
#   Node.js (非同期、イベント ドリブン JavaScript ランタイム) を使用してスケーラブルなネットワーク アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Node '                                           # [Workload] Microsoft.VisualStudio.Workload.Node
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [必須] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Node.Build '                                 # [必須] Node.js MSBuild サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Node.Tools '                                 # [必須] Node.js 開発サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TestTools.Core '                             # [必須] テスト ツールのコア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [必須] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [任意] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [任意] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [任意] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [任意] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [任意] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Office
#   Office/SharePoint 開発
#   C#、VB、JavaScript を使用して、Office アドイン、SharePoint アドイン、SharePoint ソリューション、VSTO アドインを作成します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Office '                                         # [Workload] Microsoft.VisualStudio.Workload.Office
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                      # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [必須] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [必須] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                 # [必須] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [必須] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                     # [必須] .NET Framework 4 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [必須] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [必須] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                                # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools.BuildTools '                     # [必須] コンテナーの開発ツール - Build Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Prerequisites '               # [必須] .NET デスクトップ開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Sharepoint.Tools '                           # [必須] Office Developer Tools for Visual Studio
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                   # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CMDUtils '                               # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.NCLI '                                   # [必須] SQL Server Native Client
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [必須] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [必須] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [必須] Windows Communication Foundation
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                        # [必須] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Workflow '                                   # [必須] Windows Workflow Foundation
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TeamOffice '                                 # [推奨] Visual Studio Tools for Office (VSTO)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.SDK '                                           # [任意] .NET Framework 4.6.2 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                 # [任意] .NET Framework 4.6.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.SDK '                                           # [任意] .NET Framework 4.7.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [任意] .NET Framework 4.7.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.SDK '                                           # [任意] .NET Framework 4.7.2 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [任意] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.SDK '                                             # [任意] .NET Framework 4.7 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.TargetingPack '                                   # [任意] .NET Framework 4.7 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                           # [任意] .NET Framework 4.6.2 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                           # [任意] .NET Framework 4.7.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.2.DeveloperTools '                           # [任意] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                             # [任意] .NET Framework 4.7 開発ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Python
#   Python 開発
#   Python の編集、デバッグ、対話型開発、ソース管理。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Python '                                         # [Workload] Microsoft.VisualStudio.Workload.Python
# $WorkLoads +=     '--add Microsoft.Component.PythonTools '                                             # [必須] Python 言語サポート
# $WorkLoads +=     '--add Component.CPython3.x64 '                                                      # [推奨] Python 3 64 ビット (3.6.6)
# $WorkLoads +=     '--add Microsoft.Component.CookiecutterTools '                                       # [推奨] cookiecutter テンプレートのサポート
# $WorkLoads +=     '--add Microsoft.Component.PythonTools.Web '                                         # [推奨] Python Web サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [推奨] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [推奨] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [推奨] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [推奨] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [推奨] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.Anaconda2.x64 '                                                     # [任意] Anaconda2 64 ビット (5.2.0)
# $WorkLoads +=     '--add Component.Anaconda2.x86 '                                                     # [任意] Anaconda2 32 ビット (5.2.0)
# $WorkLoads +=     '--add Component.Anaconda3.x64 '                                                     # [任意] Anaconda3 64 ビット (5.2.0)
# $WorkLoads +=     '--add Component.Anaconda3.x86 '                                                     # [任意] Anaconda3 32 ビット (5.2.0)
# $WorkLoads +=     '--add Component.CPython2.x64 '                                                      # [任意] Python 2 64 ビット (2.7.14)
# $WorkLoads +=     '--add Component.CPython2.x86 '                                                      # [任意] Python 2 32 ビット (2.7.14)
# $WorkLoads +=     '--add Component.CPython3.x86 '                                                      # [任意] Python 3 32 ビット (3.6.6)
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [任意] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                      # [任意] ライブラリ マネージャー
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [任意] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [任意] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [任意] MSBuild
# $WorkLoads +=     '--add Microsoft.Component.NetFX.Native '                                            # [任意] .NET Native
# $WorkLoads +=     '--add Microsoft.Component.PythonTools.UWP '                                         # [任意] Python IoT サポート
# $WorkLoads +=     '--add Microsoft.Component.VC.Runtime.UCRTSDK '                                      # [任意] Windows Universal CRT SDK
# $WorkLoads +=     '--add Microsoft.ComponentGroup.PythonTools.NativeDevelopment '                      # [任意] Python ネイティブ開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                 # [任意] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [任意] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [任意] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [任意] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [任意] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [任意] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [任意] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                       # [任意] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                           # [任意] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                     # [任意] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                     # [任意] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton '                             # [任意] Azure Cloud Services コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools '                  # [任意] Azure Cloud Services ビルド ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ClassDesigner '                              # [任意] クラス デザイナー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [任意] .NET プロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                                # [任意] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools.BuildTools '                     # [任意] コンテナーの開発ツール - Build Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics '                                   # [任意] イメージ エディターと 3D モデル エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [任意] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Win81 '                             # [任意] グラフィックス ツール Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [任意] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [任意] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [任意] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [任意] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [任意] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [任意] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [任意] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                   # [任意] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CMDUtils '                               # [任意] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [任意] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [任意] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.NCLI '                                   # [任意] SQL Server Native Client
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [任意] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [任意] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [任意] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.140 '                                     # [任意] デスクトップ用 VC++ 2015.3 v14.00 (v140) ツールセット
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [任意] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                         # [任意] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [任意] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                        # [任意] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK '                               # [任意] Windows ユニバーサル C ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.10586 '                         # [任意] Windows 10 SDK (10.0.10586.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [任意] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows81SDK '                               # [任意] Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [任意] ASP.NET と Web の開発ツールの前提条件

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Universal
#   ユニバーサル Windows プラットフォーム開発
#   C#、VB、JavaScript、または C++ (オプション) を使ってユニバーサル Windows プラットフォームのアプリケーションを作成します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Universal '                                      # [Workload] Microsoft.VisualStudio.Workload.Universal
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [必須] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [必須] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.NetFX.Native '                                            # [必須] .NET Native
# $WorkLoads +=     '--add Microsoft.ComponentGroup.Blend '                                              # [必須] Blend for Visual Studio
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                   # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [必須] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # [必須] .NET Core 2.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [必須] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [必須] .NET プロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics '                                   # [必須] イメージ エディターと 3D モデル エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [必須] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.UWP.Support '                                # [必須] ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [必須] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [必須] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.Cordova '                           # [必須] Cordova 用ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.NetCoreAndStandard '                # [必須] .NET ネイティブと .NET Standard
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.Xamarin '                           # [必須] Xamarin 用ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.Component.VC.Runtime.OSSupport '                                    # [任意] UWP 用の Visual C++ ランタイム
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.SDK '                                           # [任意] .NET Framework 4.7.2 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [任意] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Win81 '                             # [任意] グラフィックス ツール Windows 8.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Phone.Emulator.15254 '                       # [任意] Windows 10 Mobile エミュレーター (Fall Creators Update)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.UWP.VC.ARM64 '                               # [任意] ARM64 用 C++ ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [任意] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.ARM '                               # [任意] ARM 用 Visual C++ コンパイラとライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.ARM64 '                             # [任意] ARM64 用 Visual C++ コンパイラとライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [任意] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.10240 '                           # [任意] Windows 10 SDK (10.0.10240.0)
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.10586 '                           # [任意] Windows 10 SDK (10.0.10586.0)
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.14393 '                           # [任意] Windows 10 SDK (10.0.14393.0)
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.Desktop '                   # [任意] デスクトップ用 Windows 10 SDK (10.0.15063.0) C++ [x86 および x64]
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP '                       # [任意] UWP 用 Windows 10 SDK (10.0.15063.0):C#、VB、JS
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP.Native '                # [任意] UWP 用 Windows 10 SDK (10.0.15063.0):C++
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop '                   # [任意] デスクトップ用 Windows 10 SDK (10.0.16299.0) C++ [x86 および x64]
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop.arm '               # [任意] デスクトップ用 Windows 10 SDK (10.0.16299.0) C++ [ARM および ARM64]
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.UWP '                       # [任意] UWP 用 Windows 10 SDK (10.0.16299.0):C#、VB、JS
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299.UWP.Native '                # [任意] UWP 用 Windows 10 SDK (10.0.16299.0):C++
$WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17134 '                           # [任意] Windows 10 SDK (10.0.17134.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.IpOverUsb '                     # [任意] USB デバイスの接続
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.VC '                                # [任意] C++ ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Windows10SDK.15063 '                    # [任意] Windows 10 SDK (10.0.15063.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Windows10SDK.16299 '                    # [任意] Windows 10 SDK (10.0.16299.0)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.VisualStudioExtension
#   Visual Studio 拡張機能の開発
#   Visual Studio 用のアドオンや拡張機能 (新しいコマンド、コード アナライザー、ツール ウィンドウを含みま す) を作成します。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.VisualStudioExtension '                            # [Workload] Microsoft.VisualStudio.Workload.VisualStudioExtension
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [必須] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                 # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.SDK '                                           # [必須] .NET Framework 4.6.1 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                 # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                   # [必須] .NET Framework 4.6 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [必須] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                      # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [必須] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Static.Analysis.Tools '                      # [必須] スタティック分析ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VSSDK '                                      # [必須] Visual Studio SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.VisualStudioExtension.Prerequisites '   # [必須] Visual Studio 拡張機能の開発の前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [推奨] .NET プロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [推奨] テキスト テンプレート変換
# $WorkLoads +=     '--add Component.Dotfuscator '                                                       # [任意] PreEmptive Protection - Dotfuscator
# $WorkLoads +=     '--add Microsoft.Component.CodeAnalysis.SDK '                                        # [任意] .NET Compiler Platform SDK
# $WorkLoads +=     '--add Microsoft.Component.VC.Runtime.OSSupport '                                    # [任意] UWP 用の Visual C++ ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [任意] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ClassDesigner '                              # [任意] クラス デザイナー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DslTools '                                   # [任意] Modeling SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL '                                     # [任意] x86 用と x64 用の Visual C++ ATL
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATLMFC '                                  # [任意] x86 用と x64 用の Visual C++ MFC
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [任意] Visual Studio C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [任意] VC++ 2017 バージョン 15.9 v14.16 最新の v141 ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.WebCrossPlat
#   JavaScript でのモバイル開発
#   Tools for Apache Cordova を使用して Android、iOS、UWP 向けのアプリをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=  '--add Microsoft.VisualStudio.Workload.WebCrossPlat '                                   # [Workload] Microsoft.VisualStudio.Workload.WebCrossPlat
# $WorkLoads +=     '--add Component.CordovaToolset.6.3.1 '                                              # [必須] Cordova 6.3.1 ツールセット
# $WorkLoads +=     '--add Component.WebSocket '                                                         # [必須] WebSocket4Net
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Cordova '                                    # [必須] JavaScript でのモバイル開発のコア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.ProjectSystem '                   # [必須] JavaScript ProjectSystem と共有ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.3 '                             # [必須] TypeScript 2.3 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.1 '                             # [必須] TypeScript 3.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.Android.SDK23.Private '                                             # [任意] Android SDK セットアップ (API レベル 23) (JavaScript/C++ を使用したモバイル開発のためにローカルにインストール
# $WorkLoads +=     '--add Component.Google.Android.Emulator.API23.Private '                             # [任意] Google Android Emulator (API レベル 23) (ローカル インストール)
# $WorkLoads +=     '--add Component.HAXM.Private '                                                      # [任意] Intel Hardware Accelerated Execution Manager (HAXM) (ローカル インストール)
# $WorkLoads +=     '--add Component.OpenJDK '                                                           # [任意] Microsoft 配布の OpenJDK
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                               # [任意] ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.NetFX.Native '                                            # [任意] .NET Native
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [任意] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [任意] .NET プロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Git '                                        # [任意] Git for Windows
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics '                                   # [任意] イメージ エディターと 3D モデル エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Phone.Emulator.15254 '                       # [任意] Windows 10 Mobile エミュレーター (Fall Creators Update)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [任意] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # [任意] データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [任意] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.Cordova '                           # [任意] Cordova 用ユニバーサル Windows プラットフォーム ツール

#---------------------------------------------------------------------------------------------------------------------------------
# 関連付けられていないコンポーネント
#   以下のコンポーネントはどのワークロードにも含まれていませんが、個別のコンポーネントとして選択できます 。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=     '--add Component.Android.Emulator '                                                  # Visual Studio Emulator for Android
# $WorkLoads +=     '--add Component.Android.NDK.R11C '                                                  # Android NDK (R11C)
# $WorkLoads +=     '--add Component.Android.NDK.R11C_3264 '                                             # Android NDK (R11C) (32 ビット)
# $WorkLoads +=     '--add Component.Android.SDK23 '                                                     # Android SDK セットアップ (API レベル 23) (グローバル インストール)
# $WorkLoads +=     '--add Component.Android.SDK25 '                                                     # Android SDK セットアップ (API レベル 25)
# $WorkLoads +=     '--add Component.GitHub.VisualStudio '                                               # Visual Studio 用の GitHub 拡張機能
# $WorkLoads +=     '--add Component.Google.Android.Emulator.API23.V2 '                                  # Google Android Emulator (API レベル 23) (グローバル インストール)
# $WorkLoads +=     '--add Component.Google.Android.Emulator.API25 '                                     # Google Android Emulator (API レベル 25)
# $WorkLoads +=     '--add Microsoft.Component.Blend.SDK.WPF '                                           # Blend for Visual Studio SDK for .NET
# $WorkLoads +=     '--add Microsoft.Component.HelpViewer '                                              # ヘルプ ビューアー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DependencyValidation.Community '             # 依存関係検証
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.GraphDocument '                              # DGML エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.LinqToSql '                                  # LINQ to SQL ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Phone.Emulator '                             # Windows 10 Mobile エミュレーター (Anniversary Edition)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Phone.Emulator.15063 '                       # Windows 10 Mobile エミュレーター (Creators Update)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Runtime.Node.x86.6.4.0 '                     # Node.js v6.4.0 (x86) ベースのコンポーネント用ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Runtime.Node.x86.7.4.0 '                     # Node.js v7.4.0 (x86) ベースのコンポーネント用ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.0 '                             # TypeScript 2.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.1 '                             # TypeScript 2.1 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.2 '                             # TypeScript 2.2 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.5 '                             # TypeScript 2.5 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.6 '                             # TypeScript 2.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.7 '                             # TypeScript 2.7 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.8 '                             # TypeScript 2.8 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.2.9 '                             # TypeScript 2.9 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.0 '                             # TypeScript 3.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM '                                 # ARM 用 Visual C++ ATL
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM.Spectre '                         # Spectre の軽減策を含む ARM 用 Visual C++ ATL
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64 '                               # ARM64 用 Visual C++ ATL
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64.Spectre '                       # Spectre の軽減策を含む ARM64 用 Visual C++ ATL
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.Spectre '                             # Spectre の軽減策を含む Visual C++ ATL (x86 または x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATLMFC.Spectre '                          # Spectre の軽減策を含む x86 または x64 用 Visual C++ MFC
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ClangC2 '                                 # Clang/C2 (試験的)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM '                                 # ARM 用 Visual C++ MFC
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM.Spectre '                         # Spectre の軽減策を含む ARM 用 Visual C++ MFC
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64 '                               # ARM64 用 Visual C++ MFC
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64.Spectre '                       # Spectre の軽減策を含む ARM64 用 Visual C++ MFC サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM.Spectre '                    # VC++ 2017 バージョン 15.9 v14.16 Spectre 用ライブラリ (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM64.Spectre '                  # VC++ 2017 バージョン 15.9 v14.16 Spectre 用ライブラリ (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Runtimes.x86.x64.Spectre '                # VC++ 2017 バージョン 15.9 v14.16 Spectre 用ライブラリ (x86 および x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.14.11 '                             # VC++ 2017 バージョン 15.4 v14.11 ツールセット
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.14.12 '                             # VC++ 2017 バージョン 15.5 v14.12 ツールセット
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.14.13 '                             # VC++ 2017 バージョン 15.6 v14.13 ツールセット
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.14.14 '                             # VC++ 2017 バージョン 15.7 v14.14 ツールセット
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.14.15 '                             # VC++ 2017 バージョン 15.8 v14.15 ツールセット


$Sku = "Community"
$VSBootstrapperURL = "https://aka.ms/vs/15/release/vs_${Sku}.exe"
$VSInstallLocation = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2015\${Sku}"

$ErrorActionPreference = "Stop"

# Install VS
$exitCode = InstallVS -WorkLoads $WorkLoads -Sku $Sku -VSBootstrapperURL $VSBootstrapperURL -VSInstallLocation $VSInstallLocation

if (($exitCode -ne 0) -And ($exitCode -ne 3010))
{
  exit $exitCode
}

if (Get-Service SQLWriter -ErrorAction Ignore)
{
  Stop-Service SQLWriter
  Set-Service SQLWriter -StartupType Manual
}
if (Get-Service IpOverUsbSvc -ErrorAction Ignore)
{
  Stop-Service IpOverUsbSvc
  Set-Service IpOverUsbSvc -StartupType Manual
}

