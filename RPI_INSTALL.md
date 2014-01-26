# Installing NorthPole.Erlang On Your Raspberry Pi #

This guide will take you through the steps needed to install NorthPole.Erlang on your Raspberry Pi.

Prerequisites:

- A vanilla install of 2014-01-07-wheezy-raspbian

## Step 1 - Install erlang-mini ##

*These steps taken from [here](http://www.erlang-embedded.com/2013/09/new-erlang-package-for-small-devices-erlang-mini/).*

Open `/etc/apt/sources.list` for editing

	sudo nano /etc/apt/sources.list

Add the following line, and save

    deb http://packages.erlang-solutions.com/debian wheezy contrib

Import the Erlang Solutions public key:

    wget http://packages.erlang-solutions.com/debian/erlang_solutions.asc

    sudo apt-key add erlang_solutions.asc && rm erlang_solutions.asc

Update the package database:

    sudo apt-get update

Install erlang-mini:

    sudo apt-get install erlang-mini

## Step 2 - Install NorthPole.Erlang ##

    git clone https://github.com/SneakyBrian/NorthPole.Erlang.git
    
    cd NorthPole.Erlang

Get rebar, and make executable

    wget https://github.com/rebar/rebar/wiki/rebar
    sudo chmod 777 ./rebar

Get dependencies

    ./rebar get-deps

Build the project

    ./rebar compile

make launch script executable, and run it

    sudo chmod 777 ./launch
    sudo ./launch

Fire up browser and point to `http://<RPI_IP_ADDRESS>:4242/` to see the test page.

