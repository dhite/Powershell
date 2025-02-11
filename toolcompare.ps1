# Reviews csv file with tool name in top row and computer name using the tool following in column below.  Need to review with some test data
# dot source to make function avail ex. . .\toolcompare.ps1
function Compare-ComputerList {
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
   
    Param(
        [Parameter(
            Mandatory = $true)]

        [string]$CSV,
   
        [Parameter(
            Mandatory = $true)]
        [ValidateSet("Workstation", "Server")]
        [string]$OS
    )



Begin {
$source = Import-Csv $csv
$sourceColumn = ($Source | gm -MemberType NoteProperty).Name
$Global:Results = @()    

 }
 
Process {  

foreach ($header in $sourceColumn) {

        Add-Member -InputObject $Global:Results -MemberType NoteProperty -Name $header -Value ""
        }
 
foreach ($Row in $SourceColumn) {
        $Global:ResultsTemp = @()
        foreach ($ComputerName in $Source.$Row) {
        if ($ComputerName -ne "")
            {if ($Results.ComputerName -notcontains $ComputerName)
                {  
                    $ResultsTemp = [PSCustomObject]@{
                    ComputerName = $ComputerName
                    }
                    $ResultsTemp | Add-Member -NotePropertyName "Source$Row" -NotePropertyValue $Row
                    $Global:Results += $ResultsTemp
                }
                else{
                $Results -Match $ComputerName | Add-Member -NotePropertyName "Source$Row" -NotePropertyValue $Row -Force
                }
             }
        }
}}

End{
$properties=@("ComputerName")
foreach ($attrib in $sourceColumn) {
 
    $tempattrib = "Source$attrib"
    $properties += $tempattrib}
   
$filedate = (get-date).ToString("yyyyMMdd")
$Results |select $properties | Export-Csv -NoTypeInformation -Path ".\$filedate$OS.csv"
$Results |select $properties |ft -AutoSize
Write-Host 'To filter or Sort the above data use: $Results |select $properties'
}

}
