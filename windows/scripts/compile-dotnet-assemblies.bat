::http://support.microsoft.com/kb/2570538
::http://robrelyea.wordpress.com/2007/07/13/may-be-helpful-ngen-exe-executequeueditems/

%windir%\Microsoft.NET\Framework\v4.0.30319\Ngen.exe update /force /queue > NUL
%windir%\Microsoft.NET\Framework\v4.0.30319\Ngen.exe executequeueditems > NUL

if NOT "%PROCESSOR_ARCHITECTURE%"=="AMD64" exit 0

:64BIT
%windir%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe update /force /queue > NUL
%windir%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe executequeueditems > NUL

exit 0
