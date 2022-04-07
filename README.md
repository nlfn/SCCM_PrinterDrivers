# SCCM_PrinterDrivers
Script to install set of drivers on windows machines
reddit.com/u/nlfn

this script was created in the fall of 2021 to deal with the fallout of PrintNightmare.
- Windows settings changed to require users be a local admin to add printer drivers
- We had historically used LAPS when end-users needed to elevate, using a local computer account in the admin group whose password was managed through AD
- However Windows (rightfully) sandboxes the elevated window from the regular user's network resources
- Which meant that we couldn't use LAPS to add network printers- we needed an AD account that was also a local admin 

My initial thought was to package the most common printer drivers and expand from there, but I ran into problems trying to script and detect driver installations directly.

What ultimately worked was using an AD service account to add a representative set of print queues
- created a txt file with a print queue for each driver I wanted to install 
- This did require some adjusting of drivers on our print server so that there were no errors ("trust this machine") and would install silently.
- Running the script adds the print queues (and related drivers) for the ad service account on a given computer. 
- The script runs, writing output to a logfile and counting the number of errors.
- If there are any errors, it writes it to the log
- If there are no errors, it writes a file to the computer for detection purposes.
- If you number the detection file, you can use it when you inevitably have to change the drivers

User experience
- Script is run in the background via SCCM. 
- Script adds the print queues (and related drivers) for the ad service account on an end-user computer. 
- Other users on the computer do not see any new print queues.
- When an end-user without local admin goes to add a printer, the driver will already be there
- End-user does not require any elevated rights to add print queues.


For SCCM I created a task sequence that
- Ran the script to make sure they were on the network
- Ran the script to install the print queues (set to run using an existing AD service account with local admin rights)
- I found SCCM wasn't handling the error code returns properly from running the powershell files directly so I put them in batch files
- I also added the print queue script to our default OSD task sequence so that new machines would have drivers immediately



