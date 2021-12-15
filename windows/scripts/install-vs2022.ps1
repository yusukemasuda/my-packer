function InstallVS
{
  Param
  (
    [String] $Workloads,
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
    Write-Host "Downloading Visual Studio 2022 $Sku Installer ..."
    Invoke-WebRequest -Uri $VSBootstrapperURL -OutFile "${env:Temp}\vs_$Sku.exe"

    $FilePath = "${env:Temp}\vs_$Sku.exe"
    $Arguments = ("/c", "`"`"$FilePath`" --installPath `"$VSInstallLocation`" $Workloads  --quiet --norestart --wait --nocache`"" )

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
# Visual Studio core editor (included with Visual Studio Professional 2022)
#   The Visual Studio core shell experience, 
#   including syntax-aware code editing, source code control and work item management.
#---------------------------------------------------------------------------------------------------------------------------------
$Workloads +=  '--add Microsoft.VisualStudio.Workload.CoreEditor '                                  # [Workload] Microsoft.VisualStudio.Workload.CoreEditor
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Component.CoreEditor '                                 # [Required] Visual Studio core editor


#---------------------------------------------------------------------------------------------------------------------------------
# Azure development
#   Azure SDKs, tools, and projects for developing cloud apps and creating resources using .NET and .NET Framework.
#   Also includes tools for containerizing your application, including Docker support.
#---------------------------------------------------------------------------------------------------------------------------------
$Workloads +=  '--add Microsoft.VisualStudio.Workload.Azure '                                       # [Workload] Microsoft.VisualStudio.Workload.Azure
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [Required] Razor Language Services
#$Workloads +=  '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                         # [Required] Azure WebJobs Tools
#$Workloads +=  '--add Component.Microsoft.Web.LibraryManager '                                      # [Required] Library Manager
#$Workloads +=  '--add Component.Microsoft.WebTools.BrowserLink.WebLivePreview '                     # [Required] Web Live Preview
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Required] MSBuild
#$Workloads +=  '--add Microsoft.ComponentGroup.ClickOnce.Publish '                                  # [Required] ClickOnce Publishing for .NET
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Required] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Required] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Required] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.NetCore.Component.DevelopmentTools '                                # [Required] Development tools for .NET
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.6.0 '                                     # [Required] .NET 6.0 Runtime
#$Workloads +=  '--add Microsoft.NetCore.Component.SDK '                                             # [Required] .NET SDK
#$Workloads +=  '--add Microsoft.NetCore.Component.Web '                                             # [Required] Web development tools for .NET
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.ClientLibs '                           # [Required] Azure libraries for .NET
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [Required] Connectivity and publishing tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DockerTools '                                # [Required] Container development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp '                                     # [Required] F# language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                        # [Required] F# language support for web projects
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [Required] IIS Express
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [Required] JavaScript diagnostics
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [Required] JavaScript and TypeScript language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                 # [Required] SQL Server ODBC Driver
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                           # [Required] SQL Server Command Line Utilities
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Required] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [Required] CLR data types for SQL Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [Required] Data sources for SQL Server support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [Required] SQL Server Express 2019 LocalDB
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [Required] SQL Server Data Tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [Required] Text Template Transformation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.TSServer '                        # [Required] TypeScript Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Web '                                        # [Required] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Azure.Prerequisites '                   # [Required] Azure development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                        # [Required] Azure WebJobs Tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [Required] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [Required] ASP.NET and web development
#$Workloads +=  '--add Microsoft.Component.Azure.DataLake.Tools '                                    # [Recommended] Azure Data Lake and Stream Analytics Tools
$Workloads +=  '--add Microsoft.Net.Component.4.8.TargetingPack '                                   # [Recommended] .NET Framework 4.8 targeting pack
$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                             # [Recommended] .NET Framework 4.8 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [Recommended] Developer Analytics tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.AuthoringTools '                       # [Recommended] Azure Authoring Tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.Compute.Emulator '                     # [Recommended] Azure Compute Emulator
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.Powershell '                           # [Recommended] Azure Powershell
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.ResourceManager.Tools '                # [Recommended] Azure Resource Manager core tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.ServiceFabric.Tools '                  # [Recommended] Service Fabric Tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.Waverton '                             # [Recommended] Azure Cloud Services core tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools '                  # [Recommended] Azure Cloud Services build tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [Recommended] .NET profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [Recommended] Web Deploy
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Azure.CloudServices '                   # [Recommended] Azure Cloud Services tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Azure.ResourceManager.Tools '           # [Recommended] Azure Resource Manager tools
#$Workloads +=  '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                 # [Optional] .NET Framework 4.6.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [Optional] .NET Framework 4.7.1 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.TargetingPack '                                   # [Optional] .NET Framework 4.7 targeting pack
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.6.2-4.7.1.DeveloperTools '                     # [Optional] .NET Framework 4.6.2-4.7.1 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.SDK.4.4 '                         # [Optional] TypeScript 4.4 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [Optional] Windows Communication Foundation


#---------------------------------------------------------------------------------------------------------------------------------
# Data storage and processing
#   Connect, develop, and test data solutions with SQL Server, Azure Data Lake, or Hadoop.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.Data '                                        # [Workload] Microsoft.VisualStudio.Workload.Data
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Component.Azure.DataLake.Tools '                                    # [Recommended] Azure Data Lake and Stream Analytics Tools
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Recommended] MSBuild
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Recommended] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Recommended] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Recommended] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [Recommended] Connectivity and publishing tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                 # [Recommended] SQL Server ODBC Driver
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                           # [Recommended] SQL Server Command Line Utilities
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Recommended] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Recommended] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [Recommended] CLR data types for SQL Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [Recommended] SQL Server Express 2019 LocalDB
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [Recommended] SQL Server Data Tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [Recommended] Text Template Transformation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                             # [Optional] F# desktop language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Optional] C# and Visual Basic


#---------------------------------------------------------------------------------------------------------------------------------
# .NET desktop development
#   Build WPF, Windows Forms, and console applications using C#, Visual Basic, and F# with .NET and .NET Framework.
#---------------------------------------------------------------------------------------------------------------------------------
$Workloads +=  '--add Microsoft.VisualStudio.Workload.ManagedDesktop '                              # [Workload] Microsoft.VisualStudio.Workload.ManagedDesktop
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Component.ClickOnce '                                               # [Required] ClickOnce Publishing
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Required] MSBuild
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Required] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Required] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Required] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.6.0 '                                     # [Required] .NET 6.0 Runtime
#$Workloads +=  '--add Microsoft.NetCore.Component.SDK '                                             # [Required] .NET SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [Required] Managed Desktop Workload Core
#$Workloads +=  '--add Microsoft.VisualStudio.Component.ManagedDesktop.Prerequisites '               # [Required] .NET desktop development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [Required] CLR data types for SQL Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [Required] Text Template Transformation
$Workloads +=  '--add Component.Microsoft.VisualStudio.LiveShare.2022 '                             # [Recommended] Live Share
#$Workloads +=  '--add Microsoft.ComponentGroup.Blend '                                              # [Recommended] Blend for Visual Studio
#$Workloads +=  '--add Microsoft.ComponentGroup.ClickOnce.Publish '                                  # [Recommended] ClickOnce Publishing for .NET
$Workloads +=  '--add Microsoft.Net.Component.4.8.TargetingPack '                                   # [Recommended] .NET Framework 4.8 targeting pack
$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                             # [Recommended] .NET Framework 4.8 development tools
#$Workloads +=  '--add Microsoft.NetCore.Component.DevelopmentTools '                                # [Recommended] Development tools for .NET
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Debugger.JustInTime '                        # [Recommended] Just-In-Time debugger
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [Recommended] .NET profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DotNetModelBuilder '                         # [Recommended] ML.NET Model Builder
$Workloads +=  '--add Microsoft.VisualStudio.Component.EntityFramework '                            # [Recommended] Entity Framework 6 tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp '                                     # [Recommended] F# language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Recommended] NuGet package manager
$Workloads +=  '--add Component.Dotfuscator '                                                       # [Optional] PreEmptive Protection - Dotfuscator
#$Workloads +=  '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [Optional] Razor Language Services
#$Workloads +=  '--add Component.Microsoft.Web.LibraryManager '                                      # [Optional] Library Manager
#$Workloads +=  '--add Component.Microsoft.WebTools.BrowserLink.WebLivePreview '                     # [Optional] Web Live Preview
#$Workloads +=  '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                 # [Optional] .NET Framework 4.6.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [Optional] .NET Framework 4.7.1 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.TargetingPack '                                   # [Optional] .NET Framework 4.7 targeting pack
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.6.2-4.7.1.DeveloperTools '                     # [Optional] .NET Framework 4.6.2-4.7.1 development tools
#$Workloads +=  '--add Microsoft.NetCore.Component.Web '                                             # [Optional] Web development tools for .NET
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [Optional] Developer Analytics tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [Optional] Connectivity and publishing tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DockerTools '                                # [Optional] Container development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp.Desktop '                             # [Optional] F# desktop language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                        # [Optional] F# language support for web projects
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [Optional] IIS Express
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [Optional] JavaScript diagnostics
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [Optional] JavaScript and TypeScript language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                 # [Optional] SQL Server ODBC Driver
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                           # [Optional] SQL Server Command Line Utilities
#$Workloads +=  '--add Microsoft.VisualStudio.Component.PortableLibrary '                            # [Optional] .NET Portable Library targeting pack
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [Optional] Data sources for SQL Server support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [Optional] SQL Server Express 2019 LocalDB
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [Optional] SQL Server Data Tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.SDK.4.4 '                         # [Optional] TypeScript 4.4 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.TSServer '                        # [Optional] TypeScript Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [Optional] Windows Communication Foundation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Web '                                        # [Optional] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [Optional] Web Deploy
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.MSIX.Packaging '                        # [Optional] MSIX Packaging Tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [Optional] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [Optional] ASP.NET and web development


#---------------------------------------------------------------------------------------------------------------------------------
# Game development with Unity
#   Create 2D and 3D games with Unity, a powerful cross-platform development environment.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.ManagedGame '                                 # [Workload] Microsoft.VisualStudio.Workload.ManagedGame
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [Required] .NET Framework 4.7.1 targeting pack
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Required] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Unity '                                      # [Required] Visual Studio Tools for Unity
#$Workloads +=  '--add Component.UnityEngine.x64 '                                                   # [Recommended] Unity Hub


#---------------------------------------------------------------------------------------------------------------------------------
# Linux development with C++
#   Create and debug applications running in a Linux environment.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.NativeCrossPlat '                             # [Workload] Microsoft.VisualStudio.Workload.NativeCrossPlat
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Component.MDD.Linux '                                                         # [Required] C++ for Linux Development
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [Required] C++ core features
#$Workloads +=  '--add Component.Linux.CMake '                                                       # [Recommended] C++ CMake tools for Linux
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [Recommended] ASP.NET and web development
#$Workloads +=  '--add Component.MDD.Linux.GCC.arm '                                                 # [Optional] Embedded and IoT development tools


#---------------------------------------------------------------------------------------------------------------------------------
# Desktop development with C++
#   Build modern C++ apps for Windows using tools of your choice, including MSVC, Clang, CMake, or MSBuild.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.NativeDesktop '                               # [Workload] Microsoft.VisualStudio.Workload.NativeDesktop
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Required] MSBuild
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [Required] Text Template Transformation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [Required] C++ core features
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Redist.14.Latest '                        # [Required] C++ 2022 Redistributable Update
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core '                    # [Required] C++ core desktop features
#$Workloads +=  '--add Component.Microsoft.VisualStudio.LiveShare.2022 '                             # [Recommended] Live Share
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Debugger.JustInTime '                        # [Recommended] Just-In-Time debugger
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [Recommended] Graphics debugger and GPU profiler for DirectX
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Recommended] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ASAN '                                    # [Recommended] C++ AddressSanitizer
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL '                                     # [Recommended] C++ ATL for latest v143 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CMake.Project '                           # [Recommended] C++ CMake tools for Windows
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                         # [Recommended] C++ profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.TestAdapterForBoostTest '                 # [Recommended] Test Adapter for Boost.Test
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.TestAdapterForGoogleTest '                # [Recommended] Test Adapter for Google Test
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [Recommended] MSVC v143 - VS 2022 C++ x64/x86 build tools (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.19041 '                         # [Recommended] Windows 10 SDK (10.0.19041.0)
#$Workloads +=  '--add Component.Incredibuild '                                                      # [Optional] Incredibuild - Build Acceleration
#$Workloads +=  '--add Component.IncredibuildMenu '                                                  # [Optional] IncredibuildMenu
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Optional] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Optional] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [Optional] JavaScript diagnostics
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.140 '                                     # [Optional] MSVC v140 - VS 2015 C++ build tools (v14.00)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATLMFC '                                  # [Optional] C++ MFC for latest v143 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CLI.Support '                             # [Optional] C++/CLI support for v143 build tools (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Llvm.Clang '                              # [Optional] C++ Clang Compiler for Windows (12.0.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset '                       # [Optional] C++ Clang-cl for v143 build tools (x64/x86)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 '                         # [Optional] C++ Modules for v143 build tools (x64/x86 - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.ARM64 '                             # [Optional] MSVC v143 - VS 2022 C++ ARM64 build tools (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.x86.x64 '                            # [Optional] MSVC v141 - VS 2017 C++ x64/x86 build tools (v14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                         # [Optional] Windows 10 SDK (10.0.18362.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.20348 '                         # [Optional] Windows 10 SDK (10.0.20348.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows11SDK.22000 '                         # [Optional] Windows 11 SDK (10.0.22000.0)
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang '              # [Optional] C++ Clang tools for Windows (12.0.0 - x64/x86)
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.VC.Tools.142.x86.x64 '                  # [Optional] MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.29)


#---------------------------------------------------------------------------------------------------------------------------------
# Game development with C++
#   Use the full power of C++ to build professional games powered by DirectX, Unreal, or Cocos2d.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.NativeGame '                                  # [Workload] Microsoft.VisualStudio.Workload.NativeGame
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [Required] C++ core features
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Redist.14.Latest '                        # [Required] C++ 2022 Redistributable Update
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [Required] MSVC v143 - VS 2022 C++ x64/x86 build tools (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK '                               # [Required] Windows Universal C Runtime
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [Recommended] Graphics debugger and GPU profiler for DirectX
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ASAN '                                    # [Recommended] C++ AddressSanitizer
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                         # [Recommended] C++ profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.19041 '                         # [Recommended] Windows 10 SDK (10.0.19041.0)
#$Workloads +=  '--add Component.Android.NDK.R21E '                                                  # [Optional] Android NDK (R21E)
#$Workloads +=  '--add Component.Android.SDK25.Private '                                             # [Optional] Android SDK setup (API level 25) (local install for Mobile development with C++)
#$Workloads +=  '--add Component.Ant '                                                               # [Optional] Apache Ant (1.9.3)
#$Workloads +=  '--add Component.Cocos '                                                             # [Optional] Cocos
#$Workloads +=  '--add Component.Incredibuild '                                                      # [Optional] Incredibuild - Build Acceleration
#$Workloads +=  '--add Component.IncredibuildMenu '                                                  # [Optional] IncredibuildMenu
#$Workloads +=  '--add Component.MDD.Android '                                                       # [Optional] C++ Android development tools
#$Workloads +=  '--add Component.OpenJDK '                                                           # [Optional] OpenJDK (Microsoft distribution)
#$Workloads +=  '--add Component.Unreal '                                                            # [Optional] Unreal Engine installer
#$Workloads +=  '--add Component.Unreal.Android '                                                    # [Optional] Android IDE support for Unreal engine
#$Workloads +=  '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                 # [Optional] .NET Framework 4.6.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Optional] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Optional] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.Component.4.8.TargetingPack '                                   # [Optional] .NET Framework 4.8 targeting pack
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Optional] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.TargetingPacks.Common '                          # [Optional] .NET Framework 4.8 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet.BuildTools '                           # [Optional] NuGet targets and build tasks
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Optional] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Optional] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                         # [Optional] Windows 10 SDK (10.0.18362.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.20348 '                         # [Optional] Windows 10 SDK (10.0.20348.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows11SDK.22000 '                         # [Optional] Windows 11 SDK (10.0.22000.0)


#---------------------------------------------------------------------------------------------------------------------------------
# Mobile development with C++
#   Build cross-platform applications for iOS, Android or Windows using C++.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.NativeMobile '                                # [Workload] Microsoft.VisualStudio.Workload.NativeMobile
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Component.Android.SDK25.Private '                                             # [Required] Android SDK setup (API level 25) (local install for Mobile development with C++)
#$Workloads +=  '--add Component.OpenJDK '                                                           # [Required] OpenJDK (Microsoft distribution)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [Required] C++ core features
#$Workloads +=  '--add Component.Android.NDK.R21E '                                                  # [Recommended] Android NDK (R21E)
#$Workloads +=  '--add Component.Ant '                                                               # [Recommended] Apache Ant (1.9.3)
#$Workloads +=  '--add Component.MDD.Android '                                                       # [Recommended] C++ Android development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Component.Google.Android.Emulator.API25.Private '                             # [Optional] Google Android Emulator (API Level 25) (local install)
#$Workloads +=  '--add Component.HAXM.Private '                                                      # [Optional] Intel Hardware Accelerated Execution Manager (HAXM) (local install)
#$Workloads +=  '--add Component.Incredibuild '                                                      # [Optional] Incredibuild - Build Acceleration
#$Workloads +=  '--add Component.IncredibuildMenu '                                                  # [Optional] IncredibuildMenu
#$Workloads +=  '--add Component.MDD.IOS '                                                           # [Optional] C++ iOS development tools


#---------------------------------------------------------------------------------------------------------------------------------
# Mobile development with .NET
#   Build cross-platform applications for iOS, Android or Windows using Xamarin.
#   This includes a preview of the .NET MAUI Workload as an optional install.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.NetCrossPlat '                                # [Workload] Microsoft.VisualStudio.Workload.NetCrossPlat
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Component.Android.SDK.MAUI '                                                  # [Required] Android SDK setup (API level 31)
#$Workloads +=  '--add Component.OpenJDK '                                                           # [Required] OpenJDK (Microsoft distribution)
#$Workloads +=  '--add Component.Xamarin '                                                           # [Required] Xamarin
#$Workloads +=  '--add Component.Xamarin.RemotedSimulator '                                          # [Required] Xamarin Remoted Simulator
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Required] MSBuild
#$Workloads +=  '--add Microsoft.ComponentGroup.ClickOnce.Publish '                                  # [Required] ClickOnce Publishing for .NET
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Required] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Required] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Required] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.NetCore.Component.DevelopmentTools '                                # [Required] Development tools for .NET
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.6.0 '                                     # [Required] .NET 6.0 Runtime
#$Workloads +=  '--add Microsoft.NetCore.Component.SDK '                                             # [Required] .NET SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp '                                     # [Required] F# language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Merq '                                       # [Required] Common Xamarin internal tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MonoDebugger '                               # [Required] Mono debugger
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Required] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions.TemplateEngine '     # [Required] ASP.NET templating engine
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode


#---------------------------------------------------------------------------------------------------------------------------------
# ASP.NET and web development
#   Build web applications using ASP.NET Core, ASP.NET, HTML/JavaScript, and Containers including Docker support.
#---------------------------------------------------------------------------------------------------------------------------------
$Workloads +=  '--add Microsoft.VisualStudio.Workload.NetWeb '                                      # [Workload] Microsoft.VisualStudio.Workload.NetWeb
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [Required] Razor Language Services
#$Workloads +=  '--add Component.Microsoft.Web.LibraryManager '                                      # [Required] Library Manager
#$Workloads +=  '--add Component.Microsoft.WebTools.BrowserLink.WebLivePreview '                     # [Required] Web Live Preview
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Required] MSBuild
#$Workloads +=  '--add Microsoft.ComponentGroup.ClickOnce.Publish '                                  # [Required] ClickOnce Publishing for .NET
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Required] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Required] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Required] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.NetCore.Component.DevelopmentTools '                                # [Required] Development tools for .NET
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.6.0 '                                     # [Required] .NET 6.0 Runtime
#$Workloads +=  '--add Microsoft.NetCore.Component.SDK '                                             # [Required] .NET SDK
#$Workloads +=  '--add Microsoft.NetCore.Component.Web '                                             # [Required] Web development tools for .NET
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [Required] Connectivity and publishing tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DockerTools '                                # [Required] Container development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp '                                     # [Required] F# language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                        # [Required] F# language support for web projects
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [Required] IIS Express
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [Required] JavaScript diagnostics
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [Required] JavaScript and TypeScript language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                 # [Required] SQL Server ODBC Driver
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                           # [Required] SQL Server Command Line Utilities
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Required] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [Required] CLR data types for SQL Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [Required] Data sources for SQL Server support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [Required] SQL Server Express 2019 LocalDB
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [Required] SQL Server Data Tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [Required] Text Template Transformation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.TSServer '                        # [Required] TypeScript Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Web '                                        # [Required] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [Required] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [Required] ASP.NET and web development
$Workloads +=  '--add Component.Microsoft.VisualStudio.LiveShare.2022 '                             # [Recommended] Live Share
#$Workloads +=  '--add Component.Microsoft.VisualStudio.Web.AzureFunctions '                         # [Recommended] Azure WebJobs Tools
$Workloads +=  '--add Microsoft.Net.Component.4.8.TargetingPack '                                   # [Recommended] .NET Framework 4.8 targeting pack
$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                             # [Recommended] .NET Framework 4.8 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [Recommended] Developer Analytics tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [Recommended] .NET profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.EntityFramework '                            # [Recommended] Entity Framework 6 tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [Recommended] Web Deploy
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WslDebugging '                               # [Recommended] .NET Debugging with WSL
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.AzureFunctions '                        # [Recommended] Azure WebJobs Tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Web.CloudTools '                        # [Recommended] Cloud tools for web development
#$Workloads +=  '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                 # [Optional] .NET Framework 4.6.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [Optional] .NET Framework 4.7.1 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.TargetingPack '                                   # [Optional] .NET Framework 4.7 targeting pack
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.6.2-4.7.1.DeveloperTools '                     # [Optional] .NET Framework 4.6.2-4.7.1 development tools
#$Workloads +=  '--add microsoft.net.runtime.mono.tooling '                                          # [Optional] Shared native build tooling for Mono runtime
#$Workloads +=  '--add microsoft.net.sdk.emscripten '                                                # [Optional] Emscripten SDK compiler tooling
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.SDK.4.4 '                         # [Optional] TypeScript 4.4 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [Optional] Windows Communication Foundation
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.AdditionalWebProjectTemplates '         # [Optional] Additional project templates (previous versions)
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.IISDevelopment '                        # [Optional] Development time IIS support
#$Workloads +=  '--add wasm.tools '                                                                  # [Optional] .NET WebAssembly build tools


#---------------------------------------------------------------------------------------------------------------------------------
# Node.js development
#   Build scalable network applications using Node.js, an asynchronous event-driven JavaScript runtime.
#---------------------------------------------------------------------------------------------------------------------------------
$Workloads +=  '--add Microsoft.VisualStudio.Workload.Node '                                        # [Workload] Microsoft.VisualStudio.Workload.Node
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [Required] JavaScript diagnostics
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [Required] JavaScript and TypeScript language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Node.Tools '                                 # [Required] Node.js development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.TSServer '                        # [Required] TypeScript Server
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [Required] ASP.NET and web development
#$Workloads +=  '--add Component.Microsoft.VisualStudio.LiveShare.2022 '                             # [Recommended] Live Share
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [Recommended] Web Deploy
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [Optional] Developer Analytics tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [Optional] Connectivity and publishing tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.SDK.4.4 '                         # [Optional] TypeScript 4.4 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [Optional] C++ core features
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [Optional] MSVC v143 - VS 2022 C++ x64/x86 build tools (Latest)


#---------------------------------------------------------------------------------------------------------------------------------
# Office/SharePoint development
#   Create Office and SharePoint add-ins, SharePoint solutions, and VSTO add-ins using C#, VB, and JavaScript.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.Office '                                      # [Workload] Microsoft.VisualStudio.Workload.Office
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Component.Microsoft.VisualStudio.RazorExtension '                             # [Required] Razor Language Services
#$Workloads +=  '--add Component.Microsoft.Web.LibraryManager '                                      # [Required] Library Manager
#$Workloads +=  '--add Component.Microsoft.WebTools.BrowserLink.WebLivePreview '                     # [Required] Web Live Preview
#$Workloads +=  '--add Microsoft.Component.ClickOnce '                                               # [Required] ClickOnce Publishing
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Required] MSBuild
#$Workloads +=  '--add Microsoft.ComponentGroup.ClickOnce.Publish '                                  # [Required] ClickOnce Publishing for .NET
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Required] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Required] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Required] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.NetCore.Component.DevelopmentTools '                                # [Required] Development tools for .NET
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.6.0 '                                     # [Required] .NET 6.0 Runtime
#$Workloads +=  '--add Microsoft.NetCore.Component.SDK '                                             # [Required] .NET SDK
#$Workloads +=  '--add Microsoft.NetCore.Component.Web '                                             # [Required] Web development tools for .NET
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [Required] Developer Analytics tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [Required] Connectivity and publishing tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DockerTools '                                # [Required] Container development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp '                                     # [Required] F# language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.FSharp.WebTemplates '                        # [Required] F# language support for web projects
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IISExpress '                                 # [Required] IIS Express
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.Diagnostics '                     # [Required] JavaScript diagnostics
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [Required] JavaScript and TypeScript language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.ManagedDesktop.Core '                        # [Required] Managed Desktop Workload Core
#$Workloads +=  '--add Microsoft.VisualStudio.Component.ManagedDesktop.Prerequisites '               # [Required] .NET desktop development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSODBC.SQL '                                 # [Required] SQL Server ODBC Driver
#$Workloads +=  '--add Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils '                           # [Required] SQL Server Command Line Utilities
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Required] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Sharepoint.Tools '                           # [Required] Office Developer Tools for Visual Studio
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [Required] CLR data types for SQL Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.DataSources '                            # [Required] Data sources for SQL Server support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime '                        # [Required] SQL Server Express 2019 LocalDB
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.SSDT '                                   # [Required] SQL Server Data Tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [Required] Text Template Transformation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.TSServer '                        # [Required] TypeScript Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Wcf.Tooling '                                # [Required] Windows Communication Foundation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Web '                                        # [Required] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Workflow '                                   # [Required] Windows Workflow Foundation
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Web '                                   # [Required] ASP.NET and web development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [Required] ASP.NET and web development
#$Workloads +=  '--add Microsoft.Net.Component.4.8.TargetingPack '                                   # [Recommended] .NET Framework 4.8 targeting pack
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools '                             # [Recommended] .NET Framework 4.8 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TeamOffice '                                 # [Recommended] Visual Studio Tools for Office (VSTO)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [Recommended] Web Deploy
#$Workloads +=  '--add Microsoft.Net.Component.4.6.2.TargetingPack '                                 # [Optional] .NET Framework 4.6.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.1.TargetingPack '                                 # [Optional] .NET Framework 4.7.1 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.TargetingPack '                                   # [Optional] .NET Framework 4.7 targeting pack
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.4.6.2-4.7.1.DeveloperTools '                     # [Optional] .NET Framework 4.6.2-4.7.1 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.SDK.4.4 '                         # [Optional] TypeScript 4.4 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.Sharepoint.WIF '                        # [Optional] Windows Identity Foundation 3.5


#---------------------------------------------------------------------------------------------------------------------------------
# Python development
#   Editing, debugging, interactive development and source control for Python.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.Python '                                      # [Workload] Microsoft.VisualStudio.Workload.Python
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Component.PythonTools '                                             # [Required] Python language support
#$Workloads +=  '--add Component.CPython3.x64 '                                                      # [Recommended] Python 3 64-bit (3.9.5)
#$Workloads +=  '--add Component.CPython3.x86 '                                                      # [Optional] Python 3 32-bit (3.9.5)
#$Workloads +=  '--add Component.Microsoft.VisualStudio.LiveShare.2022 '                             # [Optional] Live Share
#$Workloads +=  '--add Microsoft.Component.PythonTools.Web '                                         # [Optional] Python web support
#$Workloads +=  '--add Microsoft.ComponentGroup.PythonTools.NativeDevelopment '                      # [Optional] Python native development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Common.Azure.Tools '                         # [Optional] Connectivity and publishing tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [Optional] Graphics debugger and GPU profiler for DirectX
#$Workloads +=  '--add Microsoft.VisualStudio.Component.JavaScript.TypeScript '                      # [Optional] JavaScript and TypeScript language support
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.SDK.4.4 '                         # [Optional] TypeScript 4.4 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TypeScript.TSServer '                        # [Optional] TypeScript Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [Optional] C++ core features
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.DiagnosticTools '                         # [Optional] C++ profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WebDeploy '                                  # [Optional] Web Deploy
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK '                               # [Optional] Windows Universal C Runtime
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.19041 '                         # [Optional] Windows 10 SDK (10.0.19041.0)
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions '                    # [Optional] ASP.NET and web development


#---------------------------------------------------------------------------------------------------------------------------------
# Universal Windows Platform development
#   Create applications for the Universal Windows Platform with C#, VB, or optionally C++.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.Universal '                                   # [Workload] Microsoft.VisualStudio.Workload.Universal
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Component.NetFX.Native '                                            # [Required] .NET Native
#$Workloads +=  '--add Microsoft.ComponentGroup.Blend '                                              # [Required] Blend for Visual Studio
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.6.0 '                                     # [Required] .NET 6.0 Runtime
#$Workloads +=  '--add Microsoft.NetCore.Component.SDK '                                             # [Required] .NET SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [Required] Developer Analytics tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [Required] .NET profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Graphics '                                   # [Required] Image and 3D model editors
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Required] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.SQL.CLR '                                    # [Required] CLR data types for SQL Server
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.19041 '                         # [Required] Windows 10 SDK (10.0.19041.0)
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.MSIX.Packaging '                        # [Required] MSIX Packaging Tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.UWP.NetCoreAndStandard '                # [Required] .NET Native and .NET Standard
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.UWP.Support '                           # [Required] Universal Windows Platform tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.UWP.Xamarin '                           # [Required] Universal Windows Platform tools for Xamarin
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Component.Microsoft.Windows.CppWinRT '                                        # [Optional] C++/WinRT
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Optional] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Graphics.Tools '                             # [Optional] Graphics debugger and GPU profiler for DirectX
#$Workloads +=  '--add Microsoft.VisualStudio.Component.UWP.VC.ARM64 '                               # [Optional] C++ Universal Windows Platform support for v143 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.UWP.VC.ARM64EC '                             # [Optional] C++ Universal Windows Platform support for v143 build tools (ARM64EC - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ARM '                         # [Optional] MSVC v142 - VS 2019 C++ ARM build tools (v14.29-16.11)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ARM64 '                       # [Optional] MSVC v142 - VS 2019 C++ ARM64 build tools (v14.29-16.11)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreBuildTools '                          # [Optional] C++ Build Tools core features
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.CoreIde '                                 # [Optional] C++ core features
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.ARM '                               # [Optional] MSVC v143 - VS 2022 C++ ARM build tools (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.ARM64 '                             # [Optional] MSVC v143 - VS 2022 C++ ARM64 build tools (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.ARM64EC '                           # [Optional] MSVC v143 - VS 2022 C++ ARM64EC build tools (Latest - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 '                           # [Optional] MSVC v143 - VS 2022 C++ x64/x86 build tools (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ARM '                                # [Optional] MSVC v141 - VS 2017 C++ ARM build tools (v14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ARM64 '                              # [Optional] MSVC v141 - VS 2017 C++ ARM64 build tools (v14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.x86.x64 '                            # [Optional] MSVC v141 - VS 2017 C++ x64/x86 build tools (v14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK '                               # [Optional] Windows Universal C Runtime
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.18362 '                         # [Optional] Windows 10 SDK (10.0.18362.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows10SDK.IpOverUsb '                     # [Optional] USB Device Connectivity
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Windows11SDK.22000 '                         # [Optional] Windows 11 SDK (10.0.22000.0)
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.UWP.VC '                                # [Optional] C++ (v143) Universal Windows Platform tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.UWP.VC.v141 '                           # [Optional] C++ (v141) Universal Windows Platform tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.UWP.VC.v142 '                           # [Optional] C++ (v142) Universal Windows Platform tools
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.VC.Tools.142.x86.x64 '                  # [Optional] MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.29)


#---------------------------------------------------------------------------------------------------------------------------------
# Visual Studio extension development
#   Create add-ons and extensions for Visual Studio, including new commands, code analyzers and tool windows.
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.VisualStudio.Workload.VisualStudioExtension '                       # [Workload] Microsoft.VisualStudio.Workload.VisualStudioExtension
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Component.MSBuild '                                                 # [Required] MSBuild
#$Workloads +=  '--add Microsoft.Net.Component.4.6.TargetingPack '                                   # [Required] .NET Framework 4.6 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.TargetingPack '                                 # [Required] .NET Framework 4.7.2 targeting pack
#$Workloads +=  '--add Microsoft.Net.Component.4.8.SDK '                                             # [Required] .NET Framework 4.8 SDK
#$Workloads +=  '--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites '                       # [Required] .NET Framework 4.7.2 development tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.NuGet '                                      # [Required] NuGet package manager
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.Compiler '                            # [Required] C# and Visual Basic Roslyn compilers
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices '                    # [Required] C# and Visual Basic
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VSSDK '                                      # [Required] Visual Studio SDK
#$Workloads +=  '--add Microsoft.VisualStudio.ComponentGroup.VisualStudioExtension.Prerequisites '   # [Required] Visual Studio extension development prerequisites
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DiagnosticTools '                            # [Recommended] .NET profiling tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.IntelliCode '                                # [Recommended] IntelliCode
#$Workloads +=  '--add Microsoft.VisualStudio.Component.TextTemplating '                             # [Recommended] Text Template Transformation
#$Workloads +=  '--add Microsoft.Component.CodeAnalysis.SDK '                                        # [Optional] .NET Compiler Platform SDK
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AppInsights.Tools '                          # [Optional] Developer Analytics tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DslTools '                                   # [Optional] Modeling SDK


#---------------------------------------------------------------------------------------------------------------------------------
# Unaffiliated components
#---------------------------------------------------------------------------------------------------------------------------------
#$Workloads +=  '--add Microsoft.Component.HelpViewer '                                              # Help Viewer
#$Workloads +=  '--add Microsoft.Net.Component.3.5.DeveloperTools '                                  # .NET Framework 3.5 development tools
#$Workloads +=  '--add Microsoft.Net.Component.4.6.1.SDK '                                           # .NET Framework 4.6.1 SDK
#$Workloads +=  '--add Microsoft.Net.Component.4.6.2.SDK '                                           # .NET Framework 4.6.2 SDK
#$Workloads +=  '--add Microsoft.Net.Component.4.7.1.SDK '                                           # .NET Framework 4.7.1 SDK
#$Workloads +=  '--add Microsoft.Net.Component.4.7.2.SDK '                                           # .NET Framework 4.7.2 SDK
#$Workloads +=  '--add Microsoft.Net.Component.4.7.SDK '                                             # .NET Framework 4.7 SDK
#$Workloads +=  '--add Microsoft.Net.Core.Component.SDK.2.1 '                                        # .NET Core 2.1 Runtime (out of support)
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.3.1 '                                     # .NET Core 3.1 Runtime (LTS)
#$Workloads +=  '--add Microsoft.NetCore.Component.Runtime.5.0 '                                     # .NET 5.0 Runtime
#$Workloads +=  '--add Microsoft.NetCore.ComponentGroup.DevelopmentTools.2.1 '                       # Development Tools for .NET Core 2.1 (out of support)
#$Workloads +=  '--add Microsoft.NetCore.ComponentGroup.Web.2.1 '                                    # Web development tools for .NET Core 2.1 (out of support)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.AzureDevOps.OfficeIntegration '              # Azure DevOps Office Integration
#$Workloads +=  '--add Microsoft.VisualStudio.Component.ClassDesigner '                              # Class Designer
#$Workloads +=  '--add Microsoft.VisualStudio.Component.DependencyValidation.Community '             # Dependency Validation
#$Workloads +=  '--add Microsoft.VisualStudio.Component.Git '                                        # Git for Windows
#$Workloads +=  '--add Microsoft.VisualStudio.Component.GraphDocument '                              # DGML editor
#$Workloads +=  '--add Microsoft.VisualStudio.Component.LinqToSql '                                  # LINQ to SQL tools
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ARM.Spectre '                 # MSVC v142 - VS 2019 C++ ARM Spectre-mitigated libs (v14.29-16.11)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ARM64.Spectre '               # MSVC v142 - VS 2019 C++ ARM64 Spectre-mitigated libs (v14.29-16.11)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ATL '                         # C++ v14.29 (16.11) ATL for v142 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ATL.ARM '                     # C++ v14.29 (16.11) ATL for v142 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ATL.ARM.Spectre '             # C++ v14.29 (16.11) ATL for v142 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ATL.ARM64 '                   # C++ v14.29 (16.11) ATL for v142 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ATL.ARM64.Spectre '           # C++ v14.29 (16.11) ATL for v142 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.ATL.Spectre '                 # C++ v14.29 (16.11) ATL for v142 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.CLI.Support '                 # C++/CLI support for v142 build tools (14.29-16.11)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.MFC '                         # C++ v14.29 (16.11) MFC for v142 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.MFC.ARM '                     # C++ v14.29 (16.11) MFC for v142 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.MFC.ARM.Spectre '             # C++ v14.29 (16.11) MFC for v142 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.MFC.ARM64 '                   # C++ v14.29 (16.11) MFC for v142 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.MFC.ARM64.Spectre '           # C++ v14.29 (16.11) MFC for v142 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.MFC.Spectre '                 # C++ v14.29 (16.11) MFC for v142 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.x86.x64 '                     # MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.29-16.11)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.29.16.11.x86.x64.Spectre '             # MSVC v142 - VS 2019 C++ x64/x86 Spectre-mitigated libs (v14.29-16.11)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ARM '                          # MSVC v143 - VS 2022 C++ ARM build tools (v14.30-17.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ARM.Spectre '                  # MSVC v143 - VS 2022 C++ ARM Spectre-mitigated libs (v14.30-17.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ARM64 '                        # MSVC v143 - VS 2022 C++ ARM64 build tools (v14.30-17.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ARM64.Spectre '                # MSVC v143 - VS 2022 C++ ARM64 Spectre-mitigated libs (v14.30-17.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ATL '                          # C++ v14.30 (17.0) ATL for v143 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ATL.ARM '                      # C++ v14.30 (17.0) ATL for v143 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ATL.ARM.Spectre '              # C++ v14.30 (17.0) ATL for v143 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ATL.ARM64 '                    # C++ v14.30 (17.0) ATL for v143 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ATL.ARM64.Spectre '            # C++ v14.30 (17.0) ATL for v143 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.ATL.Spectre '                  # C++ v14.30 (17.0) ATL for v143 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.CLI.Support '                  # C++/CLI support for v143 build tools (14.30-17.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.MFC '                          # C++ v14.30 (17.0) MFC for v143 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.MFC.ARM '                      # C++ v14.30 (17.0) MFC for v143 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.MFC.ARM.Spectre '              # C++ v14.30 (17.0) MFC for v143 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.MFC.ARM64 '                    # C++ v14.30 (17.0) MFC for v143 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.MFC.ARM64.Spectre '            # C++ v14.30 (17.0) MFC for v143 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.MFC.Spectre '                  # C++ v14.30 (17.0) MFC for v143 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.x86.x64 '                      # MSVC v143 - VS 2022 C++ x64/x86 build tools (v14.30-17.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.14.30.17.0.x86.x64.Spectre '              # MSVC v143 - VS 2022 C++ x64/x86 Spectre-mitigated libs (v14.30-17.0)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL.ARM '                                 # C++ ATL for latest v143 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL.ARM.Spectre '                         # C++ ATL for latest v143 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64 '                               # C++ ATL for latest v143 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64.Spectre '                       # C++ ATL for latest v143 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64EC '                             # C++ ATL for latest v143 build tools (ARM64EC - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL.ARM64EC.Spectre '                     # C++ ATL for latest v143 build tools with Spectre Mitigations (ARM64EC - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATL.Spectre '                             # C++ ATL for latest v143 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.ATLMFC.Spectre '                          # C++ MFC for latest v143 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.MFC.ARM '                                 # C++ MFC for latest v143 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.MFC.ARM.Spectre '                         # C++ MFC for latest v143 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64 '                               # C++ MFC for latest v143 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64.Spectre '                       # C++ MFC for latest v143 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64EC '                             # C++ MFC for latest v143 build tools (ARM64EC - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.MFC.ARM64EC.Spectre '                     # C++ MFC for latest v143 build tools with Spectre Mitigations (ARM64EC - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Redist.MSM '                              # C++ 2022 Redistributable MSMs
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM.Spectre '                    # MSVC v143 - VS 2022 C++ ARM Spectre-mitigated libs (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM64.Spectre '                  # MSVC v143 - VS 2022 C++ ARM64 Spectre-mitigated libs (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Runtimes.ARM64EC.Spectre '                # MSVC v143 - VS 2022 C++ ARM64EC Spectre-mitigated libs (Latest - experimental)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.Runtimes.x86.x64.Spectre '                # MSVC v143 - VS 2022 C++ x64/x86 Spectre-mitigated libs (Latest)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ARM.Spectre '                        # MSVC v141 - VS 2017 C++ ARM Spectre-mitigated libs (v14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ARM64.Spectre '                      # MSVC v141 - VS 2017 C++ ARM64 Spectre-mitigated libs (v14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ATL '                                # C++ ATL for v141 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM '                            # C++ ATL for v141 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM.Spectre '                    # C++ ATL for v141 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM64 '                          # C++ ATL for v141 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ATL.ARM64.Spectre '                  # C++ ATL for v141 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.ATL.Spectre '                        # C++ ATL for v141 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.CLI.Support '                        # C++/CLI support for v141 build tools (14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.MFC '                                # C++ MFC for v141 build tools (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM '                            # C++ MFC for v141 build tools (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM.Spectre '                    # C++ MFC for v141 build tools with Spectre Mitigations (ARM)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM64 '                          # C++ MFC for v141 build tools (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.MFC.ARM64.Spectre '                  # C++ MFC for v141 build tools with Spectre Mitigations (ARM64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.MFC.Spectre '                        # C++ MFC for v141 build tools with Spectre Mitigations (x86 & x64)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VC.v141.x86.x64.Spectre '                    # MSVC v141 - VS 2017 C++ x64/x86 Spectre-mitigated libs (v14.16)
#$Workloads +=  '--add Microsoft.VisualStudio.Component.VisualStudioData '                           # Data sources and service references
#$Workloads +=  '--add Microsoft.VisualStudio.Component.WinXP '                                      # C++ Windows XP Support for VS 2017 (v141) tools [Deprecated]
#$Workloads +=  '--add Microsoft.VisualStudio.Web.Mvc4.ComponentGroup '                              # ASP.NET MVC 4


$Sku = "Community"
# https://visualstudio.microsoft.com/ja/thank-you-downloading-visual-studio/?sku=community&rel=17
$VSBootstrapperURL = "https://aka.ms/vs/17/release/vs_${Sku}.exe"
$VSInstallLocation = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\${Sku}"

$ErrorActionPreference = "Stop"

# Install VS
$exitCode = InstallVS -Workloads $Workloads -Sku $Sku -VSBootstrapperURL $VSBootstrapperURL -VSInstallLocation $VSInstallLocation

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

