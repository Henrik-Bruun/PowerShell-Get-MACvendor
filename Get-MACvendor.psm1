Function Get-MACvendor {


    <#
    .SYNOPSIS
        Get the vendor information for a given MAC address using an external API.
    .DESCRIPTION
        This function retrieves the vendor information associated with a MAC address
        by querying an external API (https://api.macvendors.com/).
    .PARAMETER MACAddress
        The MAC address, or part of, for which you want to retrieve the vendor information.
    .EXAMPLE
        Get-MACvendor -MACAddress "001A.2B3C.4D5E"
    .EXAMPLE
        Get-MACvendor -MACAddress "00:1A:2B:3C:4D:5E"
    .EXAMPLE
        Get-MACvendor -MACAddress "00-1A-2B-3C-4D-5E"
    .EXAMPLE
        Get-MACvendor -MACAddress "001A.2B"
    .NOTES
        Author: Henrik Bruun  Github.com @Henrik-Bruun
        Version: 1.0 2023 December.
    #>

    param (
        [string]$MACAddress
    )

    $MACAddress = $MACAddress.ToLower() -replace '[-:.\.]',''
    $apiUrl = "https://api.macvendors.com/"

    # Test if valid chr in Mac address
    $hexPattern = '^[0-9a-f]+$'

    if ($MACAddress -match $hexPattern) {
        # Test length of MAC address
        if ($MACAddress.Length -gt 5 -and $MACAddress.Length -le 12) {
            try {
                $response = Invoke-RestMethod -Uri "$apiUrl$MACAddress" -Method Get

                if ($response.length -gt 1) {
                    #Write-Output "MAC Address: $($MACAddress)"
                    #Write-Output "Vendor: $($response)"
                } else {
                    Write-Output "Error: Not Found"
                }
            } 
                catch {
                $Errormsg = "$_.Exception.Message"

                # Use regex to extract the JSON portion
                $jsonPattern = '\{.*\}'
                $jsonMatch = $Errormsg | Select-String -Pattern $jsonPattern -AllMatches | ForEach-Object { $_.Matches.Value }

                # Check if a JSON portion was found
                if ($jsonMatch) {
                    # Convert the JSON string to a PowerShell object
                    $jsonObject = $jsonMatch | ConvertFrom-Json

                    # Access the error detail
                    $errorDetail = $jsonObject.errors.detail
                    $ErrorMsge = $jsonObject.errors.message
                } 
                    else {
                    # Write-Output "No JSON portion found in the input string."
                }
            }
        } 
        else {
            # Wrong Length
            $errorDetail = "Wrong input"
            $ErrorMsge = "Input length needs to be 6 to 12 characters long + separators .-:"
            $Errormsg = $errorDetail + ", " + $ErrorMsge
        }
    } 
    else {
        # Wrong Characters input
        $errorDetail = "Wrong input"
        $ErrorMsge = "Valid characters [0-9A-Fa-f]"
        $Errormsg = $errorDetail + ", " + $ErrorMsge
    }

    $data = @(
        [pscustomobject]@{
            MACAddress = $MACAddress;
            Vendor = $response;
            Errormsg = $Errormsg;
            ErrorDetail = $errorDetail;
            ErrorMessage = $ErrorMsge
        }
    )
    $data
}
