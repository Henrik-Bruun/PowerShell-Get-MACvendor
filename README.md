# PowerShell-Get-MACvendor
PowerShell function / module to Get-MACvendor from MAC address.

I needed a function to convert MAC addresses to  Vendors

Example

Get-MACvendor -MACAddress "003096"

MACAddress   : 003096
Vendor       : Cisco Systems, Inc
Errormsg     : 
ErrorDetail  : 
ErrorMessage : 

If you ask to fast, you get this error message.
  MACAddress   : 001a2b
  Vendor       : 
  Errormsg     : {"errors":{"detail":"Too Many Requests","message":"Please slow down your requests or upgrade your plan at https://macvendors.com"}}.Exception.Message
  ErrorDetail  : Too Many Requests
  ErrorMessage : Please slow down your requests or upgrade your plan at https://macvendors.com

If you ask with non hex chr, you get this error message.
  MACAddress   : 001a2h
  Vendor       : 
  Errormsg     : Wrong input, Valid characters [0-9A-Fa-f]
  ErrorDetail  : Wrong input
  ErrorMessage : Valid characters [0-9A-Fa-f]

If you ask with to short or to long input, you get this error message.
  MACAddress   : 001a2
  Vendor       : 
  Errormsg     : Wrong input, Input length needs to be 6 to 12 characters long + separators .-:
  ErrorDetail  : Wrong input
  ErrorMessage : Input length needs to be 6 to 12 characters long + separators .-:
