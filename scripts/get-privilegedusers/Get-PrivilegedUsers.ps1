# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Directory.Read.All", "RoleManagement.Read.All"

# Get all directory roles (admin roles)
$adminRoles = Get-MgDirectoryRole -All

# For each role, get the members
$privilegedUsers = @()
foreach ($role in $adminRoles) {
    $members = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id
    foreach ($member in $members) {
        $privilegedUsers += [PSCustomObject]@{
            UserPrincipalName = (Get-MgUser -UserId $member.Id).UserPrincipalName
            RoleName          = $role.DisplayName
            RoleId            = $role.Id
        }
    }
}

# Export results
$privilegedUsers | Export-Csv -Path "PrivilegeAudit_$(Get-Date -Format 'yyyyMMdd').csv" -NoTypeInformation
$privilegedUsers | Format-Table -AutoSize