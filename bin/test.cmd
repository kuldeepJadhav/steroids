echo -- Steroids Windows Testrun --
echo without specs, because those wont run (0 specs, 0 failures)
echo wat.

echo no tests here, see appveyor.yml

exit /B 1

steroids create __testApp --type=mpa --language=coffee
cd __testApp

steroids logout
steroids generate
steroids make

cd ..

:success
echo "SUCCESS"
exit /B 0

:errur
echo ERRUR occurred
echo errorlevel: %errorlevel%
exit /B 1
