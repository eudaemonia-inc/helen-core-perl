The code that uses various APIs we need passwords or access tokens to
(e.g., Smartsheet, Google Sheets, Targetprocess) currently obtains
them from the GNOME keyring, which is less than an optimal solution as
the keyring is only usually unlocked when logged in on the desktop.

To store the relevant access token for a user, use the
"authorize_helen.pl" script in the bin directory.

authorize_helen.pl email-address service-name

where email-address is the email address used in the Agent that is
used as the identity object, and service-name is the name of class in
the Helen::Service namespace (currently GoogleSheets, Smartsheet, or
Targetprocess).

This will either give you a URL to visit from which you need to get
the access token from the URL you are redirected to after granting
access or prompt you to input the access token generated from the web
site, depending on how the web app does it.

--- roadmap, linux desktop appliance version ---

With a single command, I should be able to bootstrap a VM and have it ask me for its name and my name
and have it connect to the cloud and start monitoring queue counts.

I need to start documenting what the actual interface is to the Perl modules.

I need a bug tracking system and the first bug is to update the copyright notices.

These authorizations need to be in the unlocked GNOME keyring for the tests to pass:
hermit@acm.org GoogleSheets

