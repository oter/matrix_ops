@echo off
SET icarus_binaries=C:\iverilog\bin
SET project_dir=C:\Users\satur\workspaceSigasi\2course
SET source_files=%project_dir%\testbench.v %project_dir%\matrix_mult_vector.v
SET binary_name=test

taskkill /IM gtkwave.exe > NUL 2>&1

CD /D %project_dir%
del %binary_name% > NUL 2>&1
del out.vcd > NUL 2>&1
%icarus_binaries%\iverilog.exe -o %project_dir%\%binary_name% %source_files%
if errorlevel 1 (
   echo Build error %errorlevel%
   exit /b %errorlevel%
)
%icarus_binaries%\vvp.exe %project_dir%\%binary_name%
%icarus_binaries%\gtkwave.exe out.vcd