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
    Write-Host "Downloading Visual Studio 2019 $Sku Installer ..."
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
#   構文認識コード編集機能、ソース コード管理、作業項目管理などの Visual Studio の基本的なシェル エクスペリエンス。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.CoreEditor '                                      # [Workload] Microsoft.VisualStudio.Workload.CoreEditor
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CoreEditor '                                # [必須] Visual Studio のコア エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.StartPageExperiment.Cpp '                   # [任意] C++ ユーザー用 Visual Studio スタート ページ

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Azure
#   NET Core と .NET Framework を使用してクラウド アプリを開発し、リソースを作成するための Azure SDK、ツール、プロジェクト。
#   Docker のサポートなど、アプリケーションをコンテナー化するためのツールも含まれています。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Azure '                                           # [Workload] Microsoft.VisualStudio.Workload.Azure
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                            # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                        # [必須] Azure WebJobs ツール
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                     # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [必須] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [必須] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [必須] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [必須] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.DevelopmentTools '                               # [必須] .NET Core 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [必須] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.NetCore.Component.Web '                                            # [必須] .NET Core 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                      # [必須] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                          # [必須] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                    # [必須] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                    # [必須] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                             # [必須] Cloud Explorer
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                               # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                    # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                       # [必須] Web プロジェクト用の F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                       # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                # [必須] SQL Server ODBC Driver
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                          # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                  # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                           # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                       # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                  # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [必須] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                       # [必須] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Azure.Prerequisites '                  # [必須] Azure 開発の前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                       # [必須] Azure WebJobs ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                  # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.Component.Azure.DataLake.Tools '                                   # [推奨] Azure Data Lake と Stream Analytics ツール
$WorkLoads +=       '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                # [推奨] .NET Framework 4.5.1 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.6.TargetingPack '                                  # [推奨] .NET Framework 4.6 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.TargetingPack '                                    # [推奨] .NET Framework 4 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                         # [推奨] .NET Framework 4 - 4.6 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                       # [推奨] .NET Core 2.1 LTS ランタイム
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.AspNet45 '                                  # [推奨] 高度な ASP.NET 機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Kubernetes.Tools '                    # [推奨] Visual Studio Tools for Kubernetes
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ResourceManager.Tools '               # [推奨] Azure Resource Manager コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ServiceFabric.Tools '                 # [推奨] Service Fabric Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton '                            # [推奨] Azure Cloud Services コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools '                 # [推奨] Azure Cloud Services ビルド ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.DiagnosticTools '                           # [推奨] .NET プロファイル ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.WebDeploy '                                 # [推奨] Web 配置
$WorkLoads +=       '--add Microsoft.VisualStudio.ComponentGroup.Azure.CloudServices '                  # [推奨] Azure Cloud Services ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.ComponentGroup.Azure.ResourceManager.Tools '          # [推奨] Azure Resource Manager ツール
$WorkLoads +=       '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                # [任意] .NET Framework 4.6.2 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                # [任意] .NET Framework 4.7.1 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.7.TargetingPack '                                  # [任意] .NET Framework 4.7 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.8.TargetingPack '                                  # [任意] .NET Framework 4.8 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.6.1.DeveloperTools '                          # [任意] .NET Framework 4.6.1 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                          # [任意] .NET Framework 4.6.2 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                          # [任意] .NET Framework 4.7.1 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                            # [任意] .NET Framework 4.7 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                            # [任意] .NET Framework 4.8 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.AzCopy '                      # [任意] Azure Storage AzCopy
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                               # [任意] Windows Communication Foundation

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Data
#   SQL Server、Azure Data Lake、Hadoop を使用してデータ ソリューションの接続、開発、テストを行います。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.Data '                                           # [Workload] Microsoft.VisualStudio.Workload.Data
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                            # [推奨] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                     # [推奨] ライブラリ マネージャー
# $WorkLoads +=     '--add Microsoft.Component.Azure.DataLake.Tools '                                   # [推奨] Azure Data Lake と Stream Analytics ツール
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [推奨] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                # [推奨] .NET Framework 4.5.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [推奨] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [推奨] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                  # [推奨] .NET Framework 4.6 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [推奨] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [推奨] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                    # [推奨] .NET Framework 4 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [推奨] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                         # [推奨] .NET Framework 4 - 4.6 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [推奨] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                      # [推奨] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                          # [推奨] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                    # [推奨] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                    # [推奨] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton '                            # [推奨] Azure Cloud Services コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools '                 # [推奨] Azure Cloud Services ビルド ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                             # [推奨] Cloud Explorer
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [推奨] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                               # [推奨] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                # [推奨] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [推奨] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [推奨] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                       # [推奨] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                # [推奨] SQL Server ODBC Driver
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                          # [推奨] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [推奨] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [推奨] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [推奨] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                  # [推奨] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [推奨] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                           # [推奨] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                       # [推奨] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                  # [推奨] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [推奨] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [推奨] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                       # [推奨] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                  # [推奨] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [任意] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                            # [任意] F# デスクトップ言語のサポート

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.DataScience
#   データ サイエンス アプリケーションを作成するための言語とツール (Python と F# が含まれます)。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.DataScience '                                    # [Workload] Microsoft.VisualStudio.Workload.DataScience
# $WorkLoads +=     '--add Microsoft.Component.PythonTools '                                            # [推奨] Python 言語サポート
# $WorkLoads +=     '--add Microsoft.Component.PythonTools.Minicondax64 '                               # [推奨] Python miniconda
# $WorkLoads +=     '--add Microsoft.Component.PythonTools.Web '                                        # [推奨] Python Web サポート
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [推奨] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [推奨] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                            # [推奨] F# デスクトップ言語のサポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [推奨] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [推奨] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [推奨] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [推奨] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [推奨] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                 # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.ComponentGroup.PythonTools.NativeDevelopment '                     # [任意] Python ネイティブ開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                            # [任意] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [任意] C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                        # [任意] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                          # [任意] MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK '                              # [任意] Windows ユニバーサル C ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                        # [任意] Windows 10 SDK (10.0.18362.0)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.ManagedDesktop
#   .NET Core や .NET Framework で C#、Visual Basic、F# を使用し、WPF、Windows フォーム、コンソール アプリケーションをビルドしま す。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.ManagedDesktop '                                  # [Workload] Microsoft.VisualStudio.Workload.ManagedDesktop
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [必須] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [必須] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [必須] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [必須] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                       # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Prerequisites '              # [必須] .NET デスクトップ開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [必須] テキスト テンプレート変換
$WorkLoads +=       '--add Component.Microsoft.VisualStudio.LiveShare '                                 # [推奨] Live Share
# $WorkLoads +=     '--add Microsoft.ComponentGroup.Blend '                                             # [推奨] Blend for Visual Studio
$WorkLoads +=       '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                # [推奨] .NET Framework 4.5.1 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [推奨] .NET Framework 4.5.2 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [推奨] .NET Framework 4.5 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [推奨] .NET Framework 4.6.1 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.6.TargetingPack '                                  # [推奨] .NET Framework 4.6 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.TargetingPack '                                    # [推奨] .NET Framework 4 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                         # [推奨] .NET Framework 4 - 4.6 開発ツール
$WorkLoads +=       '--add Microsoft.Net.Core.Component.SDK.2.1 '                                       # [推奨] .NET Core 2.1 LTS ランタイム
$WorkLoads +=       '--add Microsoft.NetCore.Component.DevelopmentTools '                               # [推奨] .NET Core 開発ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.Debugger.JustInTime '                       # [推奨] Just-In-Time デバッガー
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.DiagnosticTools '                           # [推奨] .NET プロファイル ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.EntityFramework '                           # [推奨] Entity Framework 6 Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                    # [推奨] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [推奨] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Component.Dotfuscator '                                                      # [任意] PreEmptive Protection - Dotfuscator
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                            # [任意] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                     # [任意] ライブラリ マネージャー
$WorkLoads +=       '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                # [任意] .NET Framework 4.6.2 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                # [任意] .NET Framework 4.7.1 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.7.TargetingPack '                                  # [任意] .NET Framework 4.7 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.8.TargetingPack '                                  # [任意] .NET Framework 4.8 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.6.1.DeveloperTools '                          # [任意] .NET Framework 4.6.1 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                          # [任意] .NET Framework 4.6.2 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                          # [任意] .NET Framework 4.7.1 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                            # [任意] .NET Framework 4.7 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                            # [任意] .NET Framework 4.8 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [任意] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                               # [任意] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                            # [任意] F# デスクトップ言語のサポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                # [任意] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [任意] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [任意] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                # [任意] SQL Server ODBC Driver
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                          # [任意] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.PortableLibrary '                           # [任意] .NET ポータブル ライブラリ Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                  # [任意] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                           # [任意] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                       # [任意] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                  # [任意] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [任意] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                               # [任意] Windows Communication Foundation
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                       # [任意] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                        # [任意] Windows 10 SDK (10.0.18362.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.MSIX.Packaging '                       # [任意] MSIX パッケージ化ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                  # [任意] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [任意] ASP.NET と Web 開発

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.ManagedGame
#   強力なクロスプラットフォーム開発環境である Unity を使って、2D および 3D ゲームを作成します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.ManagedGame '                                    # [Workload] Microsoft.VisualStudio.Workload.ManagedGame
# $WorkLoads +=     '--add Microsoft.Net.Component.3.5.DeveloperTools '                                 # [必須] .NET Framework 3.5 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                # [必須] .NET Framework 4.7.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Unity '                                     # [必須] Visual Studio Tools for Unity
# $WorkLoads +=     '--add Component.UnityEngine.x64 '                                                  # [推奨] Unity 2018.3 64 ビット エディター
# $WorkLoads +=     '--add Component.UnityEngine.x86 '                                                  # [推奨] Unity 5.6 32 ビット エディター

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeCrossPlat
#   Linux 環境で実行するアプリケーションを作成およびデバッグします。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.NativeCrossPlat '                                # [Workload] Microsoft.VisualStudio.Workload.NativeCrossPlat
# $WorkLoads +=     '--add Component.MDD.Linux '                                                        # [必須] Linux 開発用 C++
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [必須] C++ コア機能
# $WorkLoads +=     '--add Component.Linux.CMake '                                                      # [推奨] Linux 用の C++ CMake ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.MDD.Linux.GCC.arm '                                                # [任意] 埋め込み開発ツールと IoT 開発ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeDesktop
#   MSVC、Clang、CMake、または MSBuild など、自分で選択したツールを利用し、Windows 向けの C++ アプリをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.NativeDesktop '                                  # [Workload] Microsoft.VisualStudio.Workload.NativeDesktop
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [必須] C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Redist.14.Latest '                       # [必須] C++ 2019 再頒布可能パッケージの更新プログラム
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core '                   # [必須] C++ コア デスクトップ機能
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.LiveShare '                                 # [推奨] Live Share
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Debugger.JustInTime '                       # [推奨] Just-In-Time デバッガー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                            # [推奨] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [推奨] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [推奨] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL '                                    # [推奨] 最新 v142 ビルド ツールの C++ ATL (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CMake.Project '                          # [推奨] Windows 用 C++ CMake ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                        # [推奨] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.TestAdapterForBoostTest '                # [推奨] Test Adapter for Boost.Test
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.TestAdapterForGoogleTest '               # [推奨] Test Adapter for Google Test
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                          # [推奨] MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                        # [推奨] Windows 10 SDK (10.0.18362.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions.CMake '             # [推奨] JSON エディター
# $WorkLoads +=     '--add Component.Incredibuild '                                                     # [任意] IncrediBuild - ビルド アクセラレーション
# $WorkLoads +=     '--add Component.IncredibuildMenu '                                                 # [任意] IncrediBuildMenu
# $WorkLoads +=     '--add Microsoft.Component.VC.Runtime.UCRTSDK '                                     # [任意] Windows Universal CRT SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [任意] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [任意] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.140 '                                    # [任意] MSVC v140 - VS 2015 C++ ビルド ツール (v14.00)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATLMFC '                                 # [任意] 最新 v142 ビルド ツールの C++ MFC (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CLI.Support '                            # [任意] v142 ビルド ツールの C++/CLI サポート (14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Llvm.Clang '                             # [任意] Windows 用 C++ Clang コンパイラ (8.0.1)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset '                      # [任意] v142 ビルド ツールの C++ Clang-cl (x64/x86)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 '                        # [任意] v142 ビルド ツール用の C++ モジュール (x64/x86 - 実験)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.x86.x64 '                           # [任意] MSVC v141 - VS 2017 C++ x64/x86 ビルド ツール (v14.16)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299 '                        # [任意] Windows 10 SDK (10.0.16299.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17134 '                        # [任意] Windows 10 SDK (10.0.17134.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                        # [任意] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang '             # [任意] Windows 用 C++ Clang ツール (8.0.1 - x64/x86)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeGame
#   C++ を最大限に活用して、DirectX、Unreal、Cocos2d を利用するプロフェッショナルなゲームを構築します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.NativeGame '                                     # [Workload] Microsoft.VisualStudio.Workload.NativeGame
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [必須] C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Redist.14.Latest '                       # [必須] C++ 2019 再頒布可能パッケージの更新プログラム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                          # [必須] MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK '                              # [必須] Windows ユニバーサル C ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                            # [推奨] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [推奨] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                        # [推奨] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                        # [推奨] Windows 10 SDK (10.0.18362.0)
# $WorkLoads +=     '--add Component.Android.NDK.R16B '                                                 # [任意] Android NDK (R16B)
# $WorkLoads +=     '--add Component.Android.SDK25.Private '                                            # [任意] Android SDK セットアップ (API レベル 25) (C++ を使用したモバイル開発のためにローカルにインストール)
# $WorkLoads +=     '--add Component.Ant '                                                              # [任意] Apache Ant (1.9.3)
# $WorkLoads +=     '--add Component.Cocos '                                                            # [任意] Cocos
# $WorkLoads +=     '--add Component.Incredibuild '                                                     # [任意] IncrediBuild - ビルド アクセラレーション
# $WorkLoads +=     '--add Component.IncredibuildMenu '                                                 # [任意] IncrediBuildMenu
# $WorkLoads +=     '--add Component.MDD.Android '                                                      # [任意] C++ Android 開発ツール
# $WorkLoads +=     '--add Component.OpenJDK '                                                          # [任意] OpenJDK (Microsoft ディストリビューション)
# $WorkLoads +=     '--add Component.Unreal '                                                           # [任意] Unreal Engine のインストーラー
# $WorkLoads +=     '--add Component.Unreal.Android '                                                   # [任意] Unreal Engine 用の Android IDE サポート
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                # [任意] .NET Framework 4.5.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [任意] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [任意] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                # [任意] .NET Framework 4.6.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                  # [任意] .NET Framework 4.6 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [任意] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [任意] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                    # [任意] .NET Framework 4 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [任意] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                         # [任意] .NET Framework 4 - 4.6 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet.BuildTools '                          # [任意] NuGet ターゲットとビルド タスク
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [任意] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [任意] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.16299 '                        # [任意] Windows 10 SDK (10.0.16299.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17134 '                        # [任意] Windows 10 SDK (10.0.17134.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                        # [任意] Windows 10 SDK (10.0.17763.0)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NativeMobile
#   iOS、Android、Windows 向けのクロスプラットフォーム アプリケーションを、C++ を使って構築します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.NativeMobile '                                   # [Workload] Microsoft.VisualStudio.Workload.NativeMobile
# $WorkLoads +=     '--add Component.Android.SDK25.Private '                                            # [必須] Android SDK セットアップ (API レベル 25) (C++ を使用したモバイル開発のためにローカルにインストール)
# $WorkLoads +=     '--add Component.OpenJDK '                                                          # [必須] OpenJDK (Microsoft ディストリビューション)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [必須] C++ コア機能
# $WorkLoads +=     '--add Component.Android.NDK.R16B '                                                 # [推奨] Android NDK (R16B)
# $WorkLoads +=     '--add Component.Ant '                                                              # [推奨] Apache Ant (1.9.3)
# $WorkLoads +=     '--add Component.MDD.Android '                                                      # [推奨] C++ Android 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [推奨] IntelliCode
# $WorkLoads +=     '--add Component.Android.NDK.R16B_3264 '                                            # [任意] Android NDK (R16B) (32 ビット)
# $WorkLoads +=     '--add Component.Google.Android.Emulator.API25.Private '                            # [任意] Google Android Emulator (API レベル 25) (ローカル インストール)
# $WorkLoads +=     '--add Component.HAXM.Private '                                                     # [任意] Intel Hardware Accelerated Execution Manager (HAXM) (ローカル インストール)
# $WorkLoads +=     '--add Component.Incredibuild '                                                     # [任意] IncrediBuild - ビルド アクセラレーション
# $WorkLoads +=     '--add Component.IncredibuildMenu '                                                 # [任意] IncrediBuildMenu
# $WorkLoads +=     '--add Component.MDD.IOS '                                                          # [任意] C++ iOS 開発ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NetCoreTools
#   .NET Core、ASP.NET Core、HTML/JavaScript、コンテナー (Docker サポートなど) を使用して、
#   クロスプラットフォーム アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NetCoreTools '                                    # [Workload] Microsoft.VisualStudio.Workload.NetCoreTools
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                            # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                     # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [必須] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [必須] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [必須] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [必須] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.DevelopmentTools '                               # [必須] .NET Core 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [必須] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.NetCore.Component.Web '                                            # [必須] .NET Core 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                               # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                    # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                       # [必須] Web プロジェクト用の F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                       # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                # [必須] SQL Server ODBC Driver
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                          # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                  # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                           # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                       # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                  # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [必須] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                  # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [必須] ASP.NET と Web 開発
$WorkLoads +=       '--add Component.Microsoft.VisualStudio.LiveShare '                                 # [推奨] Live Share
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                        # [推奨] Azure WebJobs ツール
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.1 '                                       # [推奨] .NET Core 2.1 LTS ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                         # [推奨] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                      # [推奨] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                          # [推奨] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                    # [推奨] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                    # [推奨] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                             # [推奨] Cloud Explorer
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.DiagnosticTools '                           # [推奨] .NET プロファイル ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.Web '                                       # [推奨] ASP.NET と Web の開発ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.WebDeploy '                                 # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                       # [推奨] Azure WebJobs ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web.CloudTools '                       # [推奨] Web 開発用クラウド ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                        # [任意] Windows 10 SDK (10.0.18362.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.IISDevelopment '                       # [任意] 開発時の IIS サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.MSIX.Packaging '                       # [任意] MSIX パッケージ化ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NetCrossPlat
#   iOS、Android、Windows 向けのクロスプラットフォーム アプリケーションを、Xamarin を使って構築します。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NetCrossPlat '                                    # [Workload] Microsoft.VisualStudio.Workload.NetCrossPlat
# $WorkLoads +=     '--add Component.OpenJDK '                                                          # [必須] OpenJDK (Microsoft ディストリビューション)
# $WorkLoads +=     '--add Component.Xamarin '                                                          # [必須] Xamarin
# $WorkLoads +=     '--add Component.Xamarin.RemotedSimulator '                                         # [必須] Xamarin Remoted Simulator
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [必須] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [必須] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [必須] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.DevelopmentTools '                               # [必須] .NET Core 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [必須] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                    # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Merq '                                      # [必須] Xamarin の一般的な内部ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MonoDebugger '                              # [必須] Mono デバッガー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions.TemplateEngine '    # [必須] ASP.NET テンプレート エンジン
# $WorkLoads +=     '--add Component.Android.SDK28 '                                                    # [推奨] Android SDK セットアップ (API レベル 28)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.NetWeb
#   ASP.NET Core、ASP.NET、HTML/JavaScript、コンテナー (Docker サポートなど) を使用して、Web アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.NetWeb '                                          # [Workload] Microsoft.VisualStudio.Workload.NetWeb
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                            # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                     # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [必須] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [必須] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [必須] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [必須] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.DevelopmentTools '                               # [必須] .NET Core 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [必須] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.NetCore.Component.Web '                                            # [必須] .NET Core 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                               # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp '                                    # [必須] F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                       # [必須] Web プロジェクト用の F# 言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                       # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                # [必須] SQL Server ODBC Driver
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                          # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                  # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                           # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                       # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                  # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [必須] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                       # [必須] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                  # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [必須] ASP.NET と Web 開発
$WorkLoads +=       '--add Component.Microsoft.VisualStudio.LiveShare '                                 # [推奨] Live Share
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                        # [推奨] Azure WebJobs ツール
$WorkLoads +=       '--add Microsoft.Net.Component.4.5.1.TargetingPack '                                # [推奨] .NET Framework 4.5.1 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.6.TargetingPack '                                  # [推奨] .NET Framework 4.6 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.TargetingPack '                                    # [推奨] .NET Framework 4 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                         # [推奨] .NET Framework 4 - 4.6 開発ツール
$WorkLoads +=       '--add Microsoft.Net.Core.Component.SDK.2.1 '                                       # [推奨] .NET Core 2.1 LTS ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                         # [推奨] Developer Analytics Tools
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.AspNet45 '                                  # [推奨] 高度な ASP.NET 機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                      # [推奨] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                          # [推奨] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                    # [推奨] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                    # [推奨] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.CloudExplorer '                             # [推奨] Cloud Explorer
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.DiagnosticTools '                           # [推奨] .NET プロファイル ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.EntityFramework '                           # [推奨] Entity Framework 6 Tools
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.WebDeploy '                                 # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                       # [推奨] Azure WebJobs ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.ComponentGroup.Web.CloudTools '                       # [推奨] Web 開発用クラウド ツール
$WorkLoads +=       '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                # [任意] .NET Framework 4.6.2 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                # [任意] .NET Framework 4.7.1 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.7.TargetingPack '                                  # [任意] .NET Framework 4.7 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.Component.4.8.TargetingPack '                                  # [任意] .NET Framework 4.8 Targeting Pack
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.6.1.DeveloperTools '                          # [任意] .NET Framework 4.6.1 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                          # [任意] .NET Framework 4.6.2 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                          # [任意] .NET Framework 4.7.1 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                            # [任意] .NET Framework 4.7 開発ツール
$WorkLoads +=       '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                            # [任意] .NET Framework 4.8 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                               # [任意] Windows Communication Foundation
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.AdditionalWebProjectTemplates '        # [任意] 追加のプロジェクト テンプレート (以前のバージョン)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.IISDevelopment '                       # [任意] 開発時の IIS サポート

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Node
#   Node.js (非同期、イベント ドリブン JavaScript ランタイム) を使用してスケーラブルなネットワーク アプリケーションをビルドします。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.Node '                                           # [Workload] Microsoft.VisualStudio.Workload.Node
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Node.Tools '                                # [必須] Node.js 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [必須] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.LiveShare '                                 # [推奨] Live Share
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [推奨] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                 # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                         # [任意] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [任意] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [任意] C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                          # [任意] MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.23)

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Office
#   C#、VB、JavaScript を使用して、Office アドイン、SharePoint アドイン、SharePoint ソリューション、VSTO アドインを作成します。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.Office '                                         # [Workload] Microsoft.VisualStudio.Workload.Office
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                            # [必須] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                     # [必須] ライブラリ マネージャー
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [必須] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.1.TargetingPack '                                # [必須] .NET Framework 4.6.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [必須] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [必須] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.Component.4.TargetingPack '                                    # [必須] .NET Framework 4 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [必須] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [必須] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                         # [必須] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [必須] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                               # [必須] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                # [必須] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [必須] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [必須] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                       # [必須] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Prerequisites '              # [必須] .NET デスクトップ開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                # [必須] SQL Server ODBC Driver
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                          # [必須] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Sharepoint.Tools '                          # [必須] Office Developer Tools for Visual Studio
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                  # [必須] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                           # [必須] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                       # [必須] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                  # [必須] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [必須] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [必須] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                               # [必須] Windows Communication Foundation
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                       # [必須] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Workflow '                                  # [必須] Windows Workflow Foundation
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                  # [必須] ASP.NET と Web の開発ツールの前提条件
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [必須] ASP.NET と Web 開発
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TeamOffice '                                # [推奨] Visual Studio Tools for Office (VSTO)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                 # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                # [任意] .NET Framework 4.6.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                # [任意] .NET Framework 4.7.1 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.TargetingPack '                                  # [任意] .NET Framework 4.7 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.TargetingPack '                                  # [任意] .NET Framework 4.8 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.6.1.DeveloperTools '                          # [任意] .NET Framework 4.6.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools '                          # [任意] .NET Framework 4.6.2 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools '                          # [任意] .NET Framework 4.7.1 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools '                            # [任意] .NET Framework 4.7 開発ツール
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                            # [任意] .NET Framework 4.8 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Sharepoint.WIF '                       # [任意] Windows Identity Foundation 3.5

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Python
#   Python の編集、デバッグ、対話型開発、ソース管理。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads += '--add Microsoft.VisualStudio.Workload.Python '                                         # [Workload] Microsoft.VisualStudio.Workload.Python
# $WorkLoads +=     '--add Microsoft.Component.PythonTools '                                            # [必須] Python 言語サポート
# $WorkLoads +=     '--add Component.CPython3.x64 '                                                     # [推奨] Python 3 64 ビット (3.7.4)
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.LiveShare '                                 # [推奨] Live Share
# $WorkLoads +=     '--add Microsoft.Component.PythonTools.Minicondax64 '                               # [推奨] Python miniconda
# $WorkLoads +=     '--add Microsoft.Component.PythonTools.Web '                                        # [推奨] Python Web サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                        # [推奨] 接続および発行ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                     # [推奨] JavaScript および TypeScript の言語サポート
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TypeScript.3.6 '                            # [推奨] TypeScript 3.6 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WebDeploy '                                 # [推奨] Web 配置
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                   # [推奨] ASP.NET と Web 開発
# $WorkLoads +=     '--add Component.CPython2.x64 '                                                     # [任意] Python 2 64 ビット (2.7.16)
# $WorkLoads +=     '--add Component.CPython2.x86 '                                                     # [任意] Python 2 32 ビット (2.7.16)
# $WorkLoads +=     '--add Component.CPython3.x86 '                                                     # [任意] Python 3 32 ビット (3.7.4)
# $WorkLoads +=     '--add Component.Microsoft.VisualStudio.RazorExtension '                            # [任意] Razor 言語サービス
# $WorkLoads +=     '--add Component.Microsoft.Web.LibraryManager '                                     # [任意] ライブラリ マネージャー
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [任意] MSBuild
# $WorkLoads +=     '--add Microsoft.ComponentGroup.PythonTools.NativeDevelopment '                     # [任意] Python ネイティブ開発ツール
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.2.TargetingPack '                                # [任意] .NET Framework 4.5.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [任意] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [任意] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [任意] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [任意] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [任意] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                      # [任意] Azure Authoring Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                          # [任意] .NET 用 Azure ライブラリ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                    # [任意] Azure コンピューティング エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Storage.Emulator '                    # [任意] Azure Storage エミュレーター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton '                            # [任意] Azure Cloud Services コア ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools '                 # [任意] Azure Cloud Services ビルド ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DockerTools '                               # [任意] コンテナー開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                            # [任意] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IISExpress '                                # [任意] IIS Express
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                    # [任意] JavaScript 診断
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                       # [任意] Managed Desktop Workload コア
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                # [任意] SQL Server ODBC Driver
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                          # [任意] SQL Server コマンド ライン ユーティリティ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [任意] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [任意] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [任意] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.ADAL '                                  # [任意] SQL ADAL ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [任意] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.DataSources '                           # [任意] SQL Server サポートのためのデータ ソース
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                       # [任意] SQL Server Express 2016 LocalDB
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                  # [任意] SQL Server Data Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [任意] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [任意] C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                        # [任意] C++ のプロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                          # [任意] MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Web '                                       # [任意] ASP.NET と Web の開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK '                              # [任意] Windows ユニバーサル C ランタイム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                        # [任意] Windows 10 SDK (10.0.18362.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.Web '                                  # [任意] ASP.NET と Web の開発ツールの前提条件

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.Universal
#   C#、VB、または C++ (オプション) を使ってユニバーサル Windows プラットフォームのアプリケーションを作成します。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.Universal '                                       # [Workload] Microsoft.VisualStudio.Workload.Universal
# $WorkLoads +=     '--add Microsoft.Component.NetFX.Native '                                           # [必須] .NET Native
# $WorkLoads +=     '--add Microsoft.ComponentGroup.Blend '                                             # [必須] Blend for Visual Studio
# $WorkLoads +=     '--add Microsoft.Net.Component.4.5.TargetingPack '                                  # [必須] .NET Framework 4.5 Targeting Pack
# $WorkLoads +=     '--add Microsoft.NetCore.Component.SDK '                                            # [必須] .NET Core 3.0 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                         # [必須] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DiagnosticTools '                           # [必須] .NET プロファイル ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics '                                  # [必須] イメージ エディターと 3D モデル エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.SQL.CLR '                                   # [必須] SQL Server の CLR データ型
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                        # [必須] Windows 10 SDK (10.0.18362.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.MSIX.Packaging '                       # [必須] MSIX パッケージ化ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.NetCoreAndStandard '               # [必須] .NET ネイティブと .NET Standard
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.Support '                          # [必須] ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.Xamarin '                          # [必須] Xamarin 用ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [任意] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [任意] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Graphics.Tools '                            # [任意] DirectX 用グラフィックス デバッガーおよび GPU プロファイラー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [任意] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.UWP.VC.ARM64 '                              # [任意] v142 ビルド ツールの C++ ユニバーサル Windows プラットフォーム サポート (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                # [任意] C++ コア機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Redist.14.Latest '                       # [任意] C++ 2019 再頒布可能パッケージの更新プログラム
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.ARM '                              # [任意] MSVC v142 - VS 2019 C++ ARM ビルド ツール (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.ARM64 '                            # [任意] MSVC v142 - VS 2019 C++ ARM64 ビルド ツール (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                          # [任意] MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ARM '                               # [任意] MSVC v141 - VS 2017 C++ ARM ビルド ツール (v14.16)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ARM64 '                             # [任意] MSVC v141 - VS 2017 C++ ARM64 ビルド ツール (v14.16)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.x86.x64 '                           # [任意] MSVC v141 - VS 2017 C++ x64/x86 ビルド ツール (v14.16)
$WorkLoads +=      '--add Microsoft.VisualStudio.Component.Windows10SDK.16299 '                         # [任意] Windows 10 SDK (10.0.16299.0)
$WorkLoads +=      '--add Microsoft.VisualStudio.Component.Windows10SDK.17134 '                         # [任意] Windows 10 SDK (10.0.17134.0)
$WorkLoads +=      '--add Microsoft.VisualStudio.Component.Windows10SDK.17763 '                         # [任意] Windows 10 SDK (10.0.17763.0)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Windows10SDK.IpOverUsb '                    # [任意] USB デバイスの接続
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core '                   # [任意] C++ コア デスクトップ機能
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.VC '                               # [任意] C++ (v142) ユニバーサル Windows プラットフォーム ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.UWP.VC.v141 '                          # [任意] C++ (v141) ユニバーサル Windows プラットフォーム ツール

#---------------------------------------------------------------------------------------------------------------------------------
# Microsoft.VisualStudio.Workload.VisualStudioExtension
#   Visual Studio 用のアドオンや拡張機能 (新しいコマンド、コード アナライザー、ツール ウィンドウを含みます) を作成します。
#---------------------------------------------------------------------------------------------------------------------------------
$WorkLoads +=  '--add Microsoft.VisualStudio.Workload.VisualStudioExtension '                           # [Workload] Microsoft.VisualStudio.Workload.VisualStudioExtension
# $WorkLoads +=     '--add Microsoft.Component.MSBuild '                                                # [必須] MSBuild
# $WorkLoads +=     '--add Microsoft.Net.Component.4.6.TargetingPack '                                  # [必須] .NET Framework 4.6 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                # [必須] .NET Framework 4.7.2 Targeting Pack
# $WorkLoads +=     '--add Microsoft.Net.Component.4.8.SDK '                                            # [必須] .NET Framework 4.8 SDK
# $WorkLoads +=     '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                      # [必須] .NET Framework 4.7.2 開発ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.IntelliCode '                               # [必須] IntelliCode
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.NuGet '                                     # [必須] NuGet パッケージ マネージャー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                           # [必須] C# および Visual Basic Roslyn コンパイラ
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                   # [必須] C# および Visual Basic
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VSSDK '                                     # [必須] Visual Studio SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.ComponentGroup.VisualStudioExtension.Prerequisites '  # [必須] Visual Studio 拡張機能の開発の前提条件
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.DiagnosticTools '                           # [推奨] .NET プロファイル ツール
$WorkLoads +=       '--add Microsoft.VisualStudio.Component.TextTemplating '                            # [推奨] テキスト テンプレート変換
# $WorkLoads +=     '--add Microsoft.Component.CodeAnalysis.SDK '                                       # [任意] .NET Compiler Platform SDK
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                         # [任意] Developer Analytics Tools
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DslTools '                                  # [任意] Modeling SDK

#---------------------------------------------------------------------------------------------------------------------------------
# 関連付けられていないコンポーネント
#   以下のコンポーネントはどのワークロードにも含まれていませんが、個別のコンポーネントとして選択できます。
#---------------------------------------------------------------------------------------------------------------------------------
# $WorkLoads +=     '--add Component.GitHub.VisualStudio '                                              # Visual Studio 用の GitHub 拡張機能
# $WorkLoads +=     '--add Component.Xamarin.Inspector '                                                # Xamarin Inspector
# $WorkLoads +=     '--add Component.Xamarin.Profiler '                                                 # Xamarin Profiler
# $WorkLoads +=     '--add Component.Xamarin.Workbooks '                                                # Xamarin Workbooks
# $WorkLoads +=     '--add Microsoft.Component.ClickOnce '                                              # ClickOnce Publishing
# $WorkLoads +=     '--add Microsoft.Component.HelpViewer '                                             # ヘルプ ビューアー
$WorkLoads +=      '--add Microsoft.Net.Component.4.6.1.SDK '                                           # .NET Framework 4.6.1 SDK
$WorkLoads +=      '--add Microsoft.Net.Component.4.6.2.SDK '                                           # .NET Framework 4.6.2 SDK
$WorkLoads +=      '--add Microsoft.Net.Component.4.7.1.SDK '                                           # .NET Framework 4.7.1 SDK
$WorkLoads +=      '--add Microsoft.Net.Component.4.7.2.SDK '                                           # .NET Framework 4.7.2 SDK
$WorkLoads +=      '--add Microsoft.Net.Component.4.7.SDK '                                             # .NET Framework 4.7 SDK
# $WorkLoads +=     '--add Microsoft.Net.Core.Component.SDK.2.2 '                                       # .NET Core 2.2 ランタイム
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools.2.1 '                      # 開発ツール + .NET Core 2.1
# $WorkLoads +=     '--add Microsoft.NetCore.ComponentGroup.Web.2.1 '                                   # Web 開発ツール + .NET Core 2.1
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.AzureDevOps.OfficeIntegration '             # Azure DevOps Office Integration
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.ClassDesigner '                             # クラス デザイナー
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.DependencyValidation.Community '            # 依存関係検証
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.Git '                                       # Git for Windows
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.GraphDocument '                             # DGML エディター
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.LinqToSql '                                 # LINQ to SQL ツール
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ARM '                              # MSVC v142 - VS 2019 C++ ARM ビルド ツール (v14.20)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ARM.Spectre '                      # MSVC v142 - VS 2019 C++ ARM Spectre 軽減ライブラリ (v14.20)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ARM64 '                            # MSVC v142 - VS 2019 C++ ARM64 ビルド ツール (v14.20)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ARM64.Spectre '                    # MSVC v142 - VS 2019 C++ ARM64 Spectre 軽減ライブラリ (v14.20)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ATL '                              # v142 ビルド ツールの C++ v14.20 ATL (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ATL.ARM '                          # v142 ビルド ツールの C++ v14.20 ATL (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ATL.ARM.Spectre '                  # v142 ビルド ツール用 C++ v14.20 ATL と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ATL.ARM64 '                        # v142 ビルド ツールの C++ v14.20 ATL (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ATL.ARM64.Spectre '                # v142 ビルド ツール用 C++ v14.20 ATL と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.ATL.Spectre '                      # v142 ビルド ツール用 C++ v14.20 ATL と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.CLI.Support '                      # v142 ビルド ツールの C++/CLI サポート (14.20)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.MFC '                              # v142 ビルド ツールの C++ v14.20 MFC (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.MFC.ARM '                          # v142 ビルド ツールの C++ v14.20 MFC (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.MFC.ARM.Spectre '                  # v142 ビルド ツール用 C++ v14.20 MFC と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.MFC.ARM64 '                        # v142 ビルド ツール用 C++ v14.20 MFC (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.MFC.ARM64.Spectre '                # v142 ビルド ツール用 C++ v14.20 MFC と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.MFC.Spectre '                      # v142 ビルド ツール用 C++ v14.20 MFC と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.x86.x64 '                          # MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.20)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.20.x86.x64.Spectre '                  # MSVC v142 - VS 2019 C++ x64/x86 Spectre 軽減ライブラリ (v14.20)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ARM '                              # MSVC v142 - VS 2019 C++ ARM ビルド ツール (v14.21)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ARM.Spectre '                      # MSVC v142 - VS 2019 C++ ARM Spectre 軽減ライブラリ (v14.21)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ARM64 '                            # MSVC v142 - VS 2019 C++ ARM64 ビルド ツール (v14.21)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ARM64.Spectre '                    # MSVC v142 - VS 2019 C++ ARM64 Spectre 軽減ライブラリ (v14.21)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ATL '                              # v142 ビルド ツールの C++ v14.21 ATL (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ATL.ARM '                          # v142 ビルド ツールの C++ v14.21 ATL (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ATL.ARM.Spectre '                  # v142 ビルド ツール用 C++ v14.21 ATL と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ATL.ARM64 '                        # v142 ビルド ツールの C++ v14.21 ATL (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ATL.ARM64.Spectre '                # v142 ビルド ツール用 C++ v14.21 ATL と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.ATL.Spectre '                      # v142 ビルド ツール用 C++ v14.21 ATL と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.CLI.Support '                      # v142 ビルド ツールの C++/CLI サポート (14.21)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.MFC '                              # v142 ビルド ツールの C++ v14.21 MFC (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.MFC.ARM '                          # v142 ビルド ツールの C++ v14.21 MFC (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.MFC.ARM.Spectre '                  # v142 ビルド ツール用 C++ v14.21 MFC と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.MFC.ARM64 '                        # v142 ビルド ツール用 C++ v14.21 MFC (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.MFC.ARM64.Spectre '                # v142 ビルド ツール用 C++ v14.21 MFC と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.MFC.Spectre '                      # v142 ビルド ツール用 C++ v14.21 MFC と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.x86.x64 '                          # MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.21)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.21.x86.x64.Spectre '                  # MSVC v142 - VS 2019 C++ x64/x86 Spectre 軽減ライブラリ (v14.21)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ARM '                              # MSVC v142 - VS 2019 C++ ARM ビルド ツール (v14.22)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ARM.Spectre '                      # MSVC v142 - VS 2019 C++ ARM Spectre 軽減ライブラリ (v14.22)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ARM64 '                            # MSVC v142 - VS 2019 C++ ARM64 ビルド ツール (v14.22)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ARM64.Spectre '                    # MSVC v142 - VS 2019 C++ ARM64 Spectre 軽減ライブラリ (v14.22)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ATL '                              # v142 ビルド ツールの C++ v14.22 ATL (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ATL.ARM '                          # v142 ビルド ツールの C++ v14.22 ATL (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ATL.ARM.Spectre '                  # v142 ビルド ツール用 C++ v14.22 ATL と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ATL.ARM64 '                        # v142 ビルド ツールの C++ v14.22 ATL (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ATL.ARM64.Spectre '                # v142 ビルド ツール用 C++ v14.22 ATL と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.ATL.Spectre '                      # v142 ビルド ツール用 C++ v14.22 ATL と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.CLI.Support '                      # v142 ビルド ツールの C++/CLI サポート (14.22)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.MFC '                              # v142 ビルド ツールの C++ v14.22 MFC (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.MFC.ARM '                          # v142 ビルド ツールの C++ v14.22 MFC (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.MFC.ARM.Spectre '                  # v142 ビルド ツール用 C++ v14.22 MFC と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.MFC.ARM64 '                        # v142 ビルド ツール用 C++ v14.22 MFC (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.MFC.ARM64.Spectre '                # v142 ビルド ツール用 C++ v14.22 MFC と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.MFC.Spectre '                      # v142 ビルド ツール用 C++ v14.22 MFC と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.x86.x64 '                          # MSVC v142 - VS 2019 C++ x64/x86 ビルド ツール (v14.22)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.14.22.x86.x64.Spectre '                  # MSVC v142 - VS 2019 C++ x64/x86 Spectre 軽減ライブラリ (v14.22)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM '                                # 最新 v142 ビルド ツールの C++ ATL (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM.Spectre '                        # 最新 v142 ビルド ツール用 C++ ATL と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64 '                              # 最新 v142 ビルド ツールの C++ ATL (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64.Spectre '                      # 最新 v142 ビルド ツール用 C++ ATL と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATL.Spectre '                            # 最新 v142 ビルド ツール用 C++ ATL と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.ATLMFC.Spectre '                         # 最新 v142 ビルド ツール用 C++ MFC と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM '                                # 最新 v142 ビルド ツールの C++ MFC (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM.Spectre '                        # 最新 v142 ビルド ツール用 C++ MFC と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64 '                              # 最新 v142 ビルド ツールの C++ MFC (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64.Spectre '                      # 最新 v142 ビルド ツール用 C++ MFC と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Redist.MSM '                             # C++ 2019 再頒布可能パッケージ MSM
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM.Spectre '                   # MSVC v142 - VS 2019 C++ ARM Spectre 軽減ライブラリ (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM64.Spectre '                 # MSVC v142 - VS 2019 C++ ARM64 Spectre 軽減ライブラリ (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.Runtimes.x86.x64.Spectre '               # MSVC v142 - VS 2019 C++ x64/x86 Spectre 軽減ライブラリ (v14.23)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ARM.Spectre '                       # MSVC v141 - VS 2017 C++ ARM Spectre 軽減ライブラリ (v14.16)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ARM64.Spectre '                     # MSVC v141 - VS 2017 C++ ARM64 Spectre 軽減ライブラリ (v14.16)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ATL '                               # v141 ビルド ツールの C++ ATL (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM '                           # v141 ビルド ツールの C++ ATL (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM.Spectre '                   # v141 ビルド ツール用 C++ ATL と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM64 '                         # v141 ビルド ツールの C++ ATL (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM64.Spectre '                 # v141 ビルド ツール用 C++ ATL と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.ATL.Spectre '                       # v141 ビルド ツール用 C++ ATL と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.CLI.Support '                       # v141 ビルド ツールの C++/CLI サポート (14.16)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.MFC '                               # v141 ビルド ツールの C++ MFC (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM '                           # v141 ビルド ツールの C++ MFC (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM.Spectre '                   # v141 ビルド ツール用 C++ MFC と Spectre 軽減策 (ARM)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM64 '                         # v141 ビルド ツールの C++ MFC (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM64.Spectre '                 # v141 ビルド ツール用 C++ MFC と Spectre 軽減策 (ARM64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.MFC.Spectre '                       # v141 ビルド ツール用 C++ MFC と Spectre 軽減策 (x86 &amp; x64)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VC.v141.x86.x64.Spectre '                   # MSVC v141 - VS 2017 C++ x64/x86 Spectre 軽減ライブラリ (v14.16)
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.VisualStudioData '                          # データソースとサービス参照
# $WorkLoads +=     '--add Microsoft.VisualStudio.Component.WinXP '                                     # VS 2017 (v141) ツールの C++ Windows XP サポート [非推奨]
# $WorkLoads +=     '--add Microsoft.VisualStudio.Web.Mvc4.ComponentGroup '                             # ASP.NET MVC 4

$Sku = "Community"
$VSBootstrapperURL = "https://aka.ms/vs/16/release/vs_community.exe"
$VSInstallLocation = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community"

$ErrorActionPreference = "Stop"

# Install VS
$exitCode = InstallVS -WorkLoads $WorkLoads -Sku $Sku -VSBootstrapperURL $VSBootstrapperURL -VSInstallLocation $VSInstallLocation

if (($process.ExitCode -ne 0) -And ($process.ExitCode -ne 3010))
{
  exit $process.ExitCode
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

