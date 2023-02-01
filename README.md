## Image To Webp
[//]: ![](https://cdn.travelpulse.com/images/99999999-9999-9999-9999-999999999999/9ad39357-0a71-33e2-023b-939625f6847b/500x309.jpg)
![](https://i.ytimg.com/vi/PPQ8m8xQAs8/maxresdefault.jpg)

## Introduction

Create a bash script for download all (.png|.jpg) images from a CDN, transform to (.webp) and Load in the same CDN and teh correct directory

- s3cmd: S3cmd is a free command line tool and client for uploading, retrieving and managing data in Amazon S3 and other cloud storage service providers that use the S3 protocol

## Requeriments

- Write a bash script that allows download all (.png|.jpg) images from a CDN, transform to (.webp) and Load in the same CDN and teh correct directory

## Technologies

#### Command line

| [s3cmd](https://s3tools.org/s3cmd)  |
| :----------------------------------: |

### Image to Webp Script:

This script download, transform and load to space CDN

We have to assign execute permissions to be able to execute it correctly by Cron, otherwise it will not have execute permissions (Do not forget config your .env and add your database credentials):

```sh
chmod ugo+x script.sh 
```

Run the main script.

```sh
./script.sh
```
## Contributors

This project was written by:

- Programmer :
  - [Joan de Jesús Méndez Pool](https://github.com/JJWizardMP)