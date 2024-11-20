@REM @echo off
setlocal EnableDelayedExpansion

set LatestNet=
if [%1] NEQ [] set LatestNet=-p:LatestNet=%1
echo:Set %LatestNet%

echo:
echo:## Starting: RESTORE and BUILD...
echo: 

@REM dotnet clean %LatestNet% -v:m
dotnet build %LatestNet% -c:Release -v:m
if %ERRORLEVEL% neq 0 goto :error

echo:
echo:## Finished: RESTORE and BUILD

echo: 
echo:## Starting: TESTS...
echo:

dotnet run %LatestNet% -p:GeneratePackageOnBuild=false -c:Release --project test/FastExpressionCompiler.TestsRunner
if %ERRORLEVEL% neq 0 goto :error

dotnet run -p:GeneratePackageOnBuild=false -c:Release --project test/FastExpressionCompiler.TestsRunner.Net472
if %ERRORLEVEL% neq 0 goto :error
echo:
echo:## Finished: TESTS

echo: 
echo:## Starting: SOURCE PACKAGING...
echo:
call BuildScripts\NugetPack.bat
if %ERRORLEVEL% neq 0 goto :error
echo:
echo:## Finished: SOURCE PACKAGING
echo: 
echo:# Finished: ALL
echo:
exit /b 0

:error
echo:
echo:## :-( Failed with ERROR: %ERRORLEVEL%
echo:
exit /b %ERRORLEVEL%
