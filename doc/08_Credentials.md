
# Managing user credentials

On the server's side we prepared user logins and VPN interfaces.

Once a user signs up, we can quickly provide them with access to our services:

- generate fresh credentials for this user's login
- select a free user from the pre-registered PostgreSQL users
- select a free VPN interface and create a new shared secret; also apply the secret on the server side and activate the interface
- prepare a Zip file which contains all the necessary scripts and credentials; store it in our web server
- send an email to the user with information about downloading the prepared Zip file and how to start the connection

This process takes no more than a few seconds.
