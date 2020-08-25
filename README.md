# ETagger

bash script to do lookups of ETags to fingerprint web apps which don't give up version info readily. Inspired by the EQGRP leak which used this technique

Example usage:

````
zerokool@skynet[~]$ ./etagger.sh 1005ea7bfde-2ae

           ----------[    ETag Webapp Enumeration Tool    ]----------
                -----[  Version: 1.02  Updated: 20200824  ]-----

 [*] Found ETag: 1005ea7bfde-2ae hit for Web app: 3CX PBX Corresponding to build/version/firmware 16.0.612
````
