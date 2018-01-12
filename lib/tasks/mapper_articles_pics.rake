namespace :db do
  desc 'populate ArticlePic model'
  task populate_article_pics: :environment do
    ArticlesPic.where(text: 'hello, sup bro', parent: 3, path: 'p_19_3.jpg', priv: 23).first_or_create
    ArticlesPic.where(text: '', parent: 3, path: 'p_29_3.jpg', priv: 29).first_or_create
    ArticlesPic.where(text: '', parent: 3, path: 'p_23_3.jpg', priv: 20).first_or_create
    ArticlesPic.where(text: '', parent: 3, path: 'p_26_3.jpg', priv: 26).first_or_create

    ArticlesPic.where(text: '', parent: 12, path: 'p_30_12.jpg', priv: 30).first_or_create
    ArticlesPic.where(text: '', parent: 12, path: 'p_33_12.jpg', priv: 33).first_or_create
    ArticlesPic.where(text: '', parent: 12, path: 'p_32_12.jpg', priv: 32).first_or_create

    ArticlesPic.where(text: '#1 CONTEST WINNER', parent: 13, path: 'p_34_13.jpg', priv: 34).first_or_create
    ArticlesPic.where(text: 'Louis A. Wharton, partner at Stubbs Alderton & Markiles, LLC', parent: 13, path: 'p_35_13.png', priv: 35).first_or_create
    ArticlesPic.where(text: 'YOUR OFFICE AGENT, HOSTED THE INCUBATE, ACCELERATE AND PAY IT FORWARD FOR BUSINESS', parent: 13, path: 'p_36_13.png', priv: 36).first_or_create

    ArticlesPic.where(text: 'WHAT A DRESS', parent: 14, path: 'p_37_14.jpg', priv: 37).first_or_create
    ArticlesPic.where(text: 'THATS WHAT WE GOT', parent: 14, path: 'p_38_14.jpg', priv: 38).first_or_create
    ArticlesPic.where(text: '', parent: 14, path: 'p_39_14.jpg', priv: 39).first_or_create

    ArticlesPic.where(text: '', parent: 6, path: 'p_42_6.jpg', priv: 42).first_or_create

    ArticlesPic.where(text: '', parent: 19, path: 'p_43_19.jpg', priv: 43).first_or_create

    ArticlesPic.where(text: '', parent: 6, path: 'p_44_6.png', priv: 44).first_or_create

    ArticlesPic.where(text: '', parent: 20, path: 'p_45_20.png', priv: 45).first_or_create
  end
end
