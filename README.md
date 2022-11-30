# Shift-Manger-for-Teams
### Description

As a result of numerous inquiries for Shift manager in Microsoft Teams. Using a mailbox calendar, I made automation shifts in Microsoft Teams Auto attended or Call queues. with Microsoft Graph we get data from the calendar and filter the relevant information. we are using Aure automation (SaaS) without dependence on a local on-premise side. We schedule the script to be daily or weekly depending on your requirements. also, we building an incoming webhook that sends you a message on the Teams Channel when the script assigned the agents (if you didn't write any information on the calendar he also send you a message)



# Requirements
* we using Microsoft.Graph,MicrosoftTeams moudles you need to import them to Azure Automation.
* the user need to be without mfa and with teams communications administrator.


# Creating App registration.

Go to **App registration** in Azure. 
>Choose name and select **Register**.

![image](https://user-images.githubusercontent.com/55660350/202478020-c38e1743-d4d2-4955-b5ad-57655bfeede6.png)

![image](https://user-images.githubusercontent.com/55660350/202477598-b1498f1c-dea9-4ffe-b023-f7fe6c9c5c82.png)

Click on : **"API permissions"** 

![image](https://user-images.githubusercontent.com/55660350/202478758-55454083-836b-4c94-a3f3-19d01b91db44.png)

  click on **add a permission**
  
 Choose **Microsoft Graph** 
 
  ![image](https://user-images.githubusercontent.com/55660350/202479493-280dbbc9-3ea4-4b3e-8df2-47c04520590f.png)

Choose **Application permissions**

![image](https://user-images.githubusercontent.com/55660350/202479721-dcbc9e5e-0cf0-4813-813f-8c7261455630.png)

Choose **Calenars.Read**

![image](https://user-images.githubusercontent.com/55660350/202479888-122ec880-6717-4c55-b208-b5811740849f.png)

Choose **Delegated permissions**

![image](https://user-images.githubusercontent.com/55660350/202482470-464f4fa5-300c-4aea-bfba-bbc67a1dcd7f.png)

Choose **User.read**

![image](https://user-images.githubusercontent.com/55660350/202483050-a1835f2f-698d-43f7-abf8-184b8dafffe5.png)

after you finish to adding the permissions.
Click on **Grant admin consent..**

![image](https://user-images.githubusercontent.com/55660350/202483532-b2da338f-1fb1-4f8c-b7d0-8625262d58e3.png)

Go to - **Certificates & secrets**

![image](https://user-images.githubusercontent.com/55660350/202484534-41a19dc2-70b6-45f5-9990-f965ee747612.png)

Create a **New Client secret**

![image](https://user-images.githubusercontent.com/55660350/202484968-548df1a7-8aff-4287-8c62-2a64af2d23e8.png)

## please copy the Value it will be available only once (we will use with Value later in the script)

go to **Overview**

![image](https://user-images.githubusercontent.com/55660350/202486451-1407ab38-323c-46f0-af9e-a500d416da3c.png)

Please copy - **Application (client) ID**,**Directory (tenant) ID**, and **Secret Value** 

![image](https://user-images.githubusercontent.com/55660350/202487067-ba32134c-8731-4e14-8d78-9783f539e063.png)

# azure Automation 
The first step is to create an Azure Automation Account in your Azure subscription.

1.On the Microsoft Azure portal click on Create a resource

![image](https://user-images.githubusercontent.com/55660350/203351247-b649ccea-e698-41e8-b0b3-d1b19c5802ee.png)

2. Search for Automation and click Create.

![image](https://user-images.githubusercontent.com/55660350/203352401-b1983ce6-7b15-4847-8124-2bcac0235d6b.png)

3. Enter the information like the example below: add a name, add a Resource group if you don't have one. click on Create now.

![image](https://user-images.githubusercontent.com/55660350/203352462-58eaf932-628e-48a6-9e6d-d74510a6334e.png)

The pricing of Azure Automation is based on the number of minutes that a job runs. With each subscription, you get **500 minutes** of job run time and **744 hours** for the watchers for free per month.
![image](https://user-images.githubusercontent.com/55660350/203352965-a2a3b4ec-8f78-48d7-b300-c8bff7b7d3d8.png)

So with the **500 free minutes**, you should be able to automate most of your daily tasks And every hour more cost only **$0.12**.

## Add powershell Modules : MicrosoftTeams and Microsoft.Graph. 

now after we have **Azure Automation Account**.
we have to add the PowerShell modules used in our Runbooks scripts.
Click on **"Browse gallery"**.
![image](https://user-images.githubusercontent.com/55660350/203353935-dc61d9b6-eb64-4151-a4c3-f3933dd1597d.png)
type **"Teams"** and import the Microsoft teams module.

![image](https://user-images.githubusercontent.com/55660350/203354049-af11f390-a7d3-47e4-89de-374853e00731.png)

 **same steps for the "Microsoft.Graph" module.**
![image](https://user-images.githubusercontent.com/55660350/204786392-66a28595-8b55-4d55-b93d-833fa40ca661.png)



### Add Azure Automation Credentials
we need to set Credentials to be used by Azure Automation into our Runbooks.

## Recommended settings :
* **Username format:** @yourdomain.onmicrosoft.com.
* **Password:** extremely complex and set to Never Expire.
* **Sync Status:** Cloud only.
* **Roles:** Required two Roles for this script -Teams communications administrator.
* **Licenses:** none.
* **MFA:** not supported.


** Note** -the Runbooks do not have direct access to your Account Credential.

 we need to create Credentials accounts, go to *Credentials* and click on "Add a credenital"
 please Create 

![image](https://user-images.githubusercontent.com/55660350/204748821-4b2b4dc0-a218-4eec-8fc2-c634d68d2f9d.png)

## Create a Runbook

Go to **Azure** -> **Azure Automation Account** -> ** Process Automation** -> **Runbooks** -> **Create a runbook* -> add Name and select PowerShell as Runbook type ->** Create**

Copy and Paste the following Script into the Runbook and you be sure to replace **<AzureAutomationCredential>** with your own values.
it should be your Credential name that you created before in **Azure Credential**.
before you publish the scripts you need fill your information in the script (Azure Credential name,name of the queue,etc.) 
  
 **Azure Credential**
![image](https://user-images.githubusercontent.com/55660350/204783866-61a4c688-777b-4684-acdb-9108d1038f19.png)
  
You need to provide the parameters of your App registration (What you created above(.
  
  * **tenantId** - provide your Office 365 Tenant Id or Tenant Domain Name.
  * **ClientID** - Provide Azure AD Application (client) Id of your app
  * **clientSecret** - Provide Application client **secret key**
  
  ![image](https://user-images.githubusercontent.com/55660350/204787533-26229f1b-d594-4a83-b1da-b9ebde1021c8.png)

  please provide the Email address of your mailbox.(**example** - name@domain.com)
  
  ![image](https://user-images.githubusercontent.com/55660350/204800353-d06f71a5-5a47-4094-8477-faf3a2095a3a.png)

 ### setup incoming webhook

now we build an incoming webhook that will send us a notification message after we change agents in the shift or send us a message if it's failed.
  

open your teams click 3 dots next to the Team’s Name ->**Connectors**  

![image](https://user-images.githubusercontent.com/55660350/204803340-78290d46-46f6-4fb9-b2a2-65c4dd87c568.png)
  
  Choose **"Incoming Webhook"** and click on ** "Configure"**.
  
  ![image](https://user-images.githubusercontent.com/55660350/204803413-c56acfa8-3dab-4091-9fcc-c950a696c830.png)

Choose a **name** and click **Create**
  
 ![image](https://user-images.githubusercontent.com/55660350/204803522-c35e695e-a43f-4752-91ad-aea92884f167.png)
 
Copy the **URL**.
  
  now we need to go back to the script that we already published above.
  
  plesae provide the URI of the incoming webhook.

![image](https://user-images.githubusercontent.com/55660350/204804075-a863ed34-5c0a-4f63-b923-88138491ec7a.png)
  
    please add your **Call queue Identity** (guid Identity) Example below :
  ![image](https://user-images.githubusercontent.com/55660350/204804915-835bcceb-6381-415d-be46-2eb4bc054ee1.png)

also add again your Call queue Identity here (guid Identity) Example below :
![image](https://user-images.githubusercontent.com/55660350/204805078-4a0c84d1-b9e6-45ee-92a4-e5d50894cc88.png)
  
  
 
  
  <#
.DESCRIPTION

    Author: Elazar ohayon

        This script will create an automated shift manager with azure automation with graph API he will collect all the calendar data and filter the relevant information and implement changes on AA or CQ.
        you can manage your on-call shift by this tool you will need only to add an appointment and write the email address on the subject example - name@domain.com or name@domain.com,name2@domain.com,name3@domain.com etc.

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



#please add here the uri of your Incoming Webhook | we will 


$URI = 'https://abrait.webhook.office.com/webhookb2/a18bb3aa-10cf-4943-a86e-e5e5332aa888@4019fc1c-59be-402c-97fe-63ca9a1a1d9a/IncomingWebhook/fbaba9b67c224c01af8126648391b18c/20363d29-6f69-4e35-b05d-5c4a8fb95d00'


# @type - Must be set to `MessageCard`.
# @context - Must be set to [`https://schema.org/extensions`](<https://schema.org/extensions>).
# title - The title of the card, usually used to announce the card.
# text - The card's purpose and what it may be describing.
# activityTitle - The title of the section, such as "Test Section", displayed in bold.
# activitySubtitle - A descriptive subtitle underneath the title.
# activityText - A longer description that is usually used to describe more relevant data.

$JSON2 = @{
  "@type"    = "MessageCard"
  "@context" = "<http://schema.org/extensions>"
  "title"    = 'Teams shift manager  '
  "text"     = "  <br />  No user found  "
  
  
  "sections" = @(
    @{
      "activityTitle"    = 'Failed'
      "activitySubtitle" = '0%: '
      "activityText"     = 'Agent not found in your calendar'
     
    }
  )
} | ConvertTo-JSON




$Params2 = @{
  "URI"         = $URI
  "Method"      = 'POST'
  "Body"        = $JSON2
  "ContentType" = 'application/json'
}




if($dataupdate.Subject -eq $Null)
{
Invoke-RestMethod @Params2
}

 



$userID_list= @()

$dataupdate.Subject.split(',') | foreach {

$userID_list += (Get-CsOnlineUser -Identity $_).Identity

}

$userID_list


#please add your Call queue Identity (guid Identity) Example below :

Set-CsCallQueue -Identity "Example - ca55asdba-88asd-40asd9-920a-9b02fd8fe765" -Users $userID_list






#please add your Call queue Identity (guid Identity) Example below :


$useroutput = Get-CsCallQueue -Identity " Example - ca55e9ba-88bb-4009-920a-9b02fd8fe765"
$Outputusers = $useroutput.Agents | select @{name="Agent";Expression={Get-CsOnlineUser -Identity $_.objectid | select -expandproperty displayname}}


$neway =  ($Outputusers.agent -join ',') +  " was added to the Call Queue" 

# @type - Must be set to `MessageCard`.
# @context - Must be set to [`https://schema.org/extensions`](<https://schema.org/extensions>).
# title - The title of the card, usually used to announce the card.
# text - The card's purpose and what it may be describing.
# activityTitle - The title of the section, such as "Test Section", displayed in bold.
# activitySubtitle - A descriptive subtitle underneath the title.
# activityText - A longer description that is usually used to describe more relevant data.

$JSON = @{
  "@type"    = "MessageCard"
  "@context" = "<http://schema.org/extensions>"
  "title"    = 'Teams shift manager  '
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

Invoke-RestMethod @Params


Disconnect-MicrosoftTeams




   
  



