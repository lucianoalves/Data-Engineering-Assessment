drop table if exists people;
drop table if exists places;

create table `people` (
  `id` int not null auto_increment,
  `given_name` varchar(80) not null,
  `family_name` varchar(80) not null,
  `date_of_birth` date not null,
  `place_of_birth` varchar(80) not null,
  primary key (`id`)
);

create table `places` (
  `id` int not null auto_increment,
  `city` varchar(80) not null,
  `county` varchar(80) not null,
  `country` varchar(80) not null,
  primary key (`id`)
);