<#
.DESCRIPTION

    Author: Elazar ohayon

        This script will create an automated shift manager with azure automation with graph API the script will collect all the calendar data and filter the relevant information and implement changes on AA or CQ.
        you can manage your on-call shift by this tool you will need only to add an appointment and write the email address on the subject example - name@domain.com or name@domain.com,name2@domain.com,name3@domain.com etc.
        you will get a notification by incoming webhook to your team channel. 

#>


#please write the account name that you already created in the Credentials section  (you can create 
#account for Microsoft.Graph to Collect the data from the calendar 

$Credential = Get-AutomationPSCredential -Name 'write account name '

Connect-MSGraph -Credential $credential

#acouunt for MicrosoftTeams
$Credential = Get-AutomationPSCredential -Name 'write account name'
Connect-MicrosoftTeams -Credential $credential







#Provide your Office 365 Tenant Id or Tenant Domain Name
$tenantId = "TenantID"
  
#Provide Azure AD Application (client) Id of your app. 
$appClientId="ClientID"
  
#Provide Application client secret key
$clientSecret ="SecretValue"
  
$requestBody = @{client_id=$appClientId;client_secret=$clientSecret;grant_type="client_credentials";scope="https://graph.microsoft.com/.default";}
$oauthResponse = Invoke-RestMethod -Method Post -Uri https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token   -Body $requestBody 
$accessToken = $oauthResponse.access_token


#Provide email address with your mailbox calendar  

$userId="name@domain.com"



#Form request headers with the acquired $accessToken
$headers = @{'Content-Type'="application\json";'Authorization'="Bearer $accessToken"}
 
#Set a time zone in header to get date time values returned in the specific time zone
#$TimeZone=(Get-TimeZone).Id #Get current time zone
$TimeZone="Pacific Standard Time"
$headers.Add('Prefer', 'outlook.timezone="' + $TimeZone + '"')
 
#This request get all future, current and old events
#$apiUrl = "https://graph.microsoft.com/v1.0/users/$userId/calendar/events"
 
#We need to apply filter with meeting start time to get only upcoming events.
#Filter - the below query returns events daily. 
$beginDay  =  Get-Date -Hour 0 -Minute 00 -Second 00

$endDay = $beginDay.AddDays(1).AddSeconds(-1)


$apiUrl = "https://graph.microsoft.com/v1.0/users/$userId/calendar/events?`$filter=start/dateTime ge '$($beginDay)' and start/dateTime lt '$($endDay)'"
 
 
$Result = @()
While ($apiUrl -ne $Null)
{
$Response = Invoke-WebRequest -Method GET -Uri $apiUrl -UseBasicParsing -ContentType "application\json" -Headers $headers | ConvertFrom-Json
if($Response.value)
{
ForEach($event in  $Response.Value)
{
$Result += New-Object PSObject -property $([ordered]@{ 
Subject = $event.subject
Organizer = $event.organizer.emailAddress.name
Attendees = (($event.attendees | select -expand emailAddress) | Select -expand name) -join ','
StareTime = [DateTime]$event.start.dateTime
EndTime = [DateTime]$event.end.dateTime
IsTeamsMeeting = ($event.onlineMeetingProvider -eq 'teamsForBusiness')
Location = $event.location.displayName
IsCancelled=$event.isCancelled
})
}
}
$apiUrl = $Response.'@Odata.NextLink'
}
 
$Result 

$dayofweek = (get-date).Day


$data = $Result | select Subject,StareTime 

$dataupdate = $data | Where-Object {$_.StareTime.day -eq "$dayofweek"}



# The URI will be the URL that you previously retrieved when creating the webhook
#please add the uri of your incoming Webhook

$URI = 'please provide URL of your incoming webhook'


# @type - Must be set to `MessageCard`.
# @context - Must be set to [`https://schema.org/extensions`](<https://schema.org/extensions>).
# title - The title of the card, usually used to announce the card.
# text - The card's purpose and what it may be describing.
# activityTitle - The title of the section, such as "Test Section", displayed in bold.
# activitySubtitle - A descriptive subtitle underneath the title.
# activityText - A longer description that is usually used to describe more relevant data.

#

$JSON2 = @{
  "@type"    = "MessageCard"
  "@context" = "<http://schema.org/extensions>"
  "title"    = 'Abra Support Bot  '
  "text"     = "  <br />  No user found  "
  
  
  "sections" = @(
    @{
      "activityTitle"    = 'Failed'
      "activitySubtitle" = '0%: '
      "activityText"     = 'No agent found in your calendar'
     
    }
  )
} | ConvertTo-JSON




$Params2 = @{
  "URI"         = $URI
  "Method"      = 'POST'
  "Body"        = $JSON2
  "ContentType" = 'application/json'
}



$userID_list= @()

$dataupdate.Subject.split(',') | foreach {

$userID_list += (Get-CsOnlineUser -Identity $_).Identity

}



$userID_list

#please add your call queue identity (guid identity) 

Set-CsCallQueue -Identity "Add call queue identity" -Users $userID_list





#please add your call queue identity (guid identity) 

$useroutput = Get-CsCallQueue -Identity "Add call queue identity"
$Outputusers = $useroutput.Agents | select @{name="Agent";Expression={Get-CsOnlineUser -Identity $_.objectid | select -expandproperty displayname}}


$neway =  ($Outputusers.agent -join ',') +  " was added to  your Call Queue" 



# @type - Must be set to `MessageCard`.
# @context - Must be set to [`https://schema.org/extensions`](<https://schema.org/extensions>).
# title - The title of the card, usually used to announce the card.
# text - The card's purpose and what it may be describing.
# activityTitle - The title of the section, such as "Test Section", displayed in bold.
# activitySubtitle - A descriptive subtitle underneath the title.
# activityText - A longer description that is usually used to describe more relevant data.


#title - please add your title.

$JSON = @{
  "@type"    = "MessageCard"
  "@context" = "<http://schema.org/extensions>"
  "title"    = 'Abra Support Bot  '
  "text"     = "  <br />  $neway  "
  
  
  "sections" = @(
    @{
      "activityTitle"    = 'Completed'
      "activitySubtitle" = '100%: '
      "activityText"     = 'Have a nice day'
     
    }
  )
} | ConvertTo-JSON



# You will always be sending content in via POST and using the ContentType of 'application/json'
# The URI will be the URL that you previously retrieved when creating the webhook
$Params = @{
  "URI"         = $URI
  "Method"      = 'POST'
  "Body"        = $JSON
  "ContentType" = 'application/json'
}



if($dataupdate.Subject -eq $Null)
{
Invoke-RestMethod @Params2
}else
{
Invoke-RestMethod @Params
}

Disconnect-MicrosoftTeams







   