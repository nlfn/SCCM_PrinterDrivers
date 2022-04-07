$print_server = "printerz"

try 
{
    # do a bunch of installation stuff
    if (Test-Connection $print_server -Quiet)
    {
        [System.Environment]::Exit(0)
    } else {
        [System.Environment]::Exit(1)
    }
}
catch
{
    [System.Environment]::Exit(1)
}