# Digital Media Reserves 

[![Dependency Status](https://gemnasium.com/ucsdlib/dmr.svg)](https://gemnasium.com/ucsdlib/dmr)

DMR is a Digital Media Reserves Tool to manage videos created for the UCSD campus.

## Requirements 

* Ruby 2.2.3+
* git

## Installation

```
$ git clone git@github.com:ucsdlib/dmr.git
```

## Usage

1.Open project.

```
$ cd dmr
```

2.Checkout develop branch.

```
$ git checkout develop

```

3.Update DB.

```
$ bundle exec rake db:migrate
```

4.Update Test DB

```
$ bundle exec rake db:migrate RAILS_ENV=test
```

## Running DMR

* WEBrick

```
$ rails s
```

## DMR will be available at 

```
http://localhost:3000/dmr/ 
```

## Running the Test Suites

```
$ bundle exec rake
```
