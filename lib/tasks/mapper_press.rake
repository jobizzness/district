namespace :db do
  desc 'populate Press model'
  task populate_press: :environment do
    Press.where(title: 'DIGITAL JOURNAL', pic: 'pic_6.png', link: 'http://www.digitaljournal.com/pr/1354512', priv: '7').first_or_create
    Press.where(title: 'STILETTOGAL', pic: 'pic_7.png', link: 'http://stilettogal.com/2013/10/24/walk-a-mile-in-her-shoes-cassie-betts/', priv: '9').first_or_create
    Press.where(title: 'SILICON BEACH LA', pic: 'pic_8.png', link: 'http://social.siliconbeachla.com/post/841659/district2-png', priv: '6').first_or_create
    Press.where(title: 'Pace News', pic: 'pic_12.png', link: 'http://issuu.com/pacenews/docs/august82014-1-16pdf?e=7198166/8887383', priv: '12').first_or_create
    Press.where(title: 'FashInvest', pic: 'pic_10.png', link: 'http://www.fashinvest.com/sourcing-easy-sites/', priv: '10').first_or_create
  end
end
