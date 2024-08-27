#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE=$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT()
{
    if [ $USERID -ne 0 ]
    then
    echo -e "$R Please run the script with root priveleges $N" | tee -a $>>LoG_FILE
    exit 1
    fi
}

VALIDATE()
{
    if [ $1 -ne 0 ]
    then
    echo -e "$R $2 is... Failed $N" | tee -a $LoG_FILE
    exit 1
    else
    echo -e "$G $2 is... Success $N" | tee -a $LoG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL Server" 

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabled MySQL Server" 

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Started MySQL server" 

mysql_secure_installation --set-root-pass ExpenseApp@1 | tee -a $LoG_FILE
VALIDATE $? "serring up root password"