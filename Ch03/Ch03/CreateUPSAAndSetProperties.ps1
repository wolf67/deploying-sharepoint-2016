$sa = New-SPProfileServiceApplication -Name "User Profile Service Application" -ApplicationPool "SharePoint Web Services Default" -ProfileDBName "Profile" -SocialDBName "Social" -ProfileSyncDBName �Sync� 
New-SPProfileServiceApplicationProxy -Name "User Profile Service Application" -ServiceApplication $sa -DefaultProxyGroup 

$user = New-SPClaimsPrincipal "CORP\s-crawl" -IdentityType WindowsSamAccountName 
$security = Get-SPServiceApplicationSecurity $sa -Admin 
Grant-SPObjectSecurity $security $user "Retrieve People Data for Search Crawlers" 
Set-SPServiceApplicationSecurity $sa $security -Admin 

$user = New-SPClaimsPrincipal "CORP\user" -IdentityType WindowsSamAccountName 
$security = Get-SPServiceApplicationSecurity $sa -Admin 
Grant-SPObjectSecurity $security $user "Full Control" 
Set-SPServiceApplicationSecurity $sa $security -Admin 
$security = Get-SPServiceApplicationSecurity $sa 
Grant-SPObjectSecurity $security $user "Full Control" 
Set-SPServiceApplicationSecurity $sa $security 

$sa = Get-SPEnterpriseSearchServiceApplication 
$source = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $sa -Identity "Local SharePoint sites" 
$source.StartAddresses.Add("sps3s://sharepoint-my.learn-sp2016.com") 
$source.Update() 