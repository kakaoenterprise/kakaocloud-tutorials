
INSERT INTO book (book_Id, name, publish_Date, company, writer, status, quantity, category, recommended, image_Url)
VALUES
    ('COM.01.001', 'DOMAIN DRIVEN DESIGN',  NOW(), '위키북스',       '에릭에반스',              '최초등록', 5, '컴퓨터', true, '/images/DDD.jpeg')
   ,('COM.01.002', 'Doing Agile Right',     NOW(), 'Harvard Biz', 'Drarrell Rigby 외 2',   '최초등록', 5, '컴퓨터', true, '/images/Agile.jpeg')
   ,('COM.01.003', 'Cloud Native',          NOW(), 'OREILLY',     'Boris Scholl 외 2',     '최초등록', 5, '컴퓨터', true, '/images/cloudNative.jpeg')
   ,('COM.01.004', 'Event Storming',        NOW(), 'Leanpub',      'Alberto Brandolini',  '최초등록', 5, '컴퓨터', true, '/images/eventStorming.jpg')
   ,('HUM.01.001', 'KakaoCloud Docs',     NOW(), 'KakaoCloud',   'Ether',       '최초등록', 5, '인문',   true, '/images/kc_docs.jpg')
   ,('HUM.01.002', '라이언, 내 곁에 있어줘',      NOW(), 'Arte',         '전승환',                '최초등록', 5, '컴퓨터', true, '/images/rian_sideme.webp');


INSERT INTO category (id, name)
VALUES
    (10000001, '컴퓨터')
   ,(20000001, '과학')
   ,(30000001, '인문')
   ,(40000001, '만화');