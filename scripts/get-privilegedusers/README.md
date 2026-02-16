This script connects Microsoft Graph to Powershell, pulls all directory admin roles, and members that have each role. It exports results to a CSV automatically.

Microsoft Graph API is a RESTful API model that uses Microsoft Graph to script and automate powerful queries. I used the Graph API and PowerShell to pull all privileged users in my organization and export the results to a CSV file for easy visualization. 

With PowerShell ISE going away in Windows 11, I built the script in Microsoft VS Code. I downloaded the PowerShell extension to made sure I had all the features.

To connect to Microsoft Graph in PowerShell, I used the following command:

```powershell
Connect-MgGraph -Scopes "Directory.Read.All", "RoleManagement.Read.All"
```

Once connected, to get all the directory roles (admin roles), I used the following command: 

```powershell
$adminRoles = Get-MgDirectoryRole -All
```

To get all the members in each role I ran the command:

```powershell
$privilegedUsers = @()
foreach ($role in $adminRoles) {
    $members = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id
    foreach ($member in $members) {
        $privilegedUsers += [PSCustomObject]@{
            UserPrincipalName = (Get-MgUser -UserId $member.Id).UserPrincipalName
            RoleName = $role.DisplayName
            RoleId = $role.Id
        }
    }
}
```

Then finally to export the results into a CSV I used the following command:

```powershell
$privilegedUsers | Export-Csv -Path "PrivilegeAudit_$(Get-Date -Format 'yyyyMMdd').csv" -NoTypeInformation
$privilegedUsers | Format-Table -AutoSize
```


Running the script gave me this output visually:
<img width="2421" height="1773" alt="Code_Q0fgOSkMMZ" src="https://github.com/user-attachments/assets/45b6f58a-7b29-4bd9-8324-20e8b88b829f" />


