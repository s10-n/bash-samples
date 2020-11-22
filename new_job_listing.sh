#!/usr/bin/bash

# new_job_listing - checks the Lambda Labs website for new job listings and opens a new Thunderbird window to inquire about the position

# change the most recent job listings to old job listings
if [ -f job_listings ]
then
    mv job_listings old_job_listings
fi

# get the latest job listings from Lambda's website
wget -qO- 'boards.greenhouse.io/embed/job_board?for=lambda&b=https%3A%2F%2Flambdalabs.com%2Fcareers' |
    grep '<a data-mapped="true"' |
    grep -Eo '[^>]+</a>' |
    sed 's_</a>__' > job_listings

# check to see if any job listings have been added since last time
if diff old_job_listings job_listings | grep '>' # excludes jobs that have been removed since last time
then
    jobs=$(diff old_job_listings job_listings | grep '>' | sed 's_> __')
    echo $(diff -y --suppress-common-lines old_job_listings job_listings | wc -l) new jobs found.
    while read -r job # open up a new email window for each position
    do
	sed s_JOBPOSITION_"$job"_ email_body |
	    thunderbird -compose "to='s@lambdal.com',subject='$job Application',attachment='/home/sean/Documents/resume/resume.pdf',message='/dev/stdin'"
    done <<<"$jobs"
else
    echo No new jobs found.
fi
