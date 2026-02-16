This script connects Microsoft Graph to Powershell, pulls all directory admin roles, and members that have each role. It exports results to a CSV automatically.

Microsoft Graph API is a RESTful API model that uses Microsoft Graph to script and automate powerful queries. I used the Graph API and PowerShell to pull all privileged users in my organization and export the results to a CSV file for easy visualization. 

With PowerShell ISE going away in Windows 11, I built the script in Microsoft VS Code. I downloaded the PowerShell extension to made sure I had all the features.

To connect to Microsoft Graph in PowerShell, I used the following command:

```jsx
Connect-MgGraph -Scopes "Directory.Read.All", "RoleManagement.Read.All"
```

Once connected, to get all the directory roles (admin roles), I used the following command: 

```jsx
$adminRoles = Get-MgDirectoryRole -All
```

To get all the members in each role I ran the command:

```jsx
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

```jsx
$privilegedUsers | Export-Csv -Path "PrivilegeAudit_$(Get-Date -Format 'yyyyMMdd').csv" -NoTypeInformation
$privilegedUsers | Format-Table -AutoSize
```

For easy future use, I’ve saved the script as [`Get-PrivilegedUsers.ps](http://Get-PrivilegedUsers.ps)1`

[Get-PrivilegedUsers.ps1](attachment:0236330d-703d-4b4e-9aed-28e39e795a7e:Get-PrivilegedUsers.ps1)

Running the script gave me this output visually:
![Code_Q0fgOSkMMZ.png](attachment:e2cbb181-86e5-4394-ab67-c0c2154a3222:Code_Q0fgOSkMMZ.png)
