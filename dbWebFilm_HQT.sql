USE master
GO

CREATE DATABASE [dbWebFilm]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbWebFilm', FILENAME = N'C:\dbWebFilm.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbWebFilm_log', FILENAME = N'C:\dbWebFilm_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
USE dbWebFilm
GO
----------------------------------------------------------------------------
--TẠO CÁC BẢNG
----------------------------------------------------------------------------
CREATE TABLE tb_DanhMuc
(
    ID INT IDENTITY,
    DanhMuc NVARCHAR(120),
	ThuTu INT,
    CONSTRAINT pk_DanhMuc PRIMARY KEY(ID)
)
GO

CREATE TABLE tb_QuocGia
(
    ID INT IDENTITY,
    QuocGia NVARCHAR(50),
	ThuTu INT,
    CONSTRAINT pk_QuocGia PRIMARY KEY(ID)
)
GO

CREATE TABLE tb_Phim
(
    ID INT IDENTITY(10000,1),
    TenPhim_en VARCHAR(120) NOT NULL,
    TenPhim_vi NVARCHAR(120) NOT NULL,
	DanhMuc INT NOT NULL,
    QuocGia INT NOT NULL,
    NamPhatHanh INT NOT NULL,
    ThoiLuong INT NOT NULL,
	LuotXem INT DEFAULT 0,
	LuotThich INT DEFAULT 0,
    UrlPhim VARCHAR(1000),
	UrlHinh VARCHAR(1000),
    MoTa NVARCHAR(MAX),
	TgianCapNhat DATETIME DEFAULT GETDATE(),
	DaXoa BIT DEFAULT 0, --1: đã xóa; 0: chưa xóa
    CONSTRAINT pk_Phim PRIMARY KEY(ID),
	CONSTRAINT fk_Phim_DanhMuc FOREIGN KEY(DanhMuc) REFERENCES tb_DanhMuc(ID),
    CONSTRAINT fk_Phim_QuocGia FOREIGN KEY(QuocGia) REFERENCES tb_QuocGia(ID),
)
GO

CREATE TABLE tb_TheLoai
(
    ID INT IDENTITY,
    TheLoai NVARCHAR(120) NOT NULL,
	ThuTu INT,
    CONSTRAINT pk_TheLoai PRIMARY KEY(ID)
)
GO

CREATE TABLE tb_DaoDien
(
    ID INT IDENTITY,
    TenDaoDien NVARCHAR(120) NOT NULL,
    CONSTRAINT pk_DaoDien PRIMARY KEY(ID)
)
GO

CREATE TABLE tb_DienVien
(
    ID INT IDENTITY(1,1),
    TenDienVien NVARCHAR(120) NOT NULL,
    CONSTRAINT pk_DienVien PRIMARY KEY(ID)
)
GO

CREATE TABLE tb_Phim_TheLoai
(
	idPhim INT,
	idTheLoai INT,
	CONSTRAINT pk_Phim_TheLoai PRIMARY KEY(idPhim, idTheLoai),
	CONSTRAINT fk_Phim_TheLoai_Phim FOREIGN KEY(idPhim) REFERENCES tb_Phim(ID),
	CONSTRAINT fk_Phim_TheLoai_TheLoai FOREIGN KEY(idTheLoai) REFERENCES tb_TheLoai(ID)
)
GO

CREATE TABLE tb_Phim_DaoDien
(
    idPhim INT,
    idDaoDien INT DEFAULT 1,
    CONSTRAINT pk_Phim_DaoDien PRIMARY KEY(idPhim, idDaoDien),
    CONSTRAINT fk_Phim_DaoDien_Phim FOREIGN KEY(idPhim) REFERENCES tb_Phim(ID),
    CONSTRAINT fk_Phim_DaoDien_DaoDien FOREIGN KEY(idDaoDien) REFERENCES tb_DaoDien(ID),
)
GO

CREATE TABLE tb_Phim_DienVien
(
    idPhim INT,
    idDienVien INT DEFAULT 1,
    CONSTRAINT pk_Phim_DienVien PRIMARY KEY(idPhim, idDienVien),
    CONSTRAINT fk_Phim_DienVien_Phim FOREIGN KEY(idPhim) REFERENCES tb_Phim(ID),
    CONSTRAINT fk_Phim_DienVien_DienVien FOREIGN KEY(idDienVien) REFERENCES tb_DienVien(ID),
)
GO

CREATE TABLE tb_TaiKhoan
(
    Username VARCHAR(30) NOT NULL,
    Password VARCHAR(1000) NOT NULL,
    HoTen NVARCHAR(120),
    Email VARCHAR(120),
    SDT VARCHAR(10),
    LoaiTK BIT DEFAULT 0, --1: admin; 0: người dùng
	DaXoa BIT DEFAULT 0, --1: đã xóa; 0: chưa xóa
    CONSTRAINT pk_TaiKhoan PRIMARY KEY(Username)
)
GO

CREATE TABLE tb_DaThich
(
	Username VARCHAR(30) NOT NULL,
    idPhim INT NOT NULL,
    CONSTRAINT pk_DaThich PRIMARY KEY(Username, idPhim),
    CONSTRAINT fk_DaThich_TaiKhoan FOREIGN KEY(Username) REFERENCES tb_TaiKhoan(Username),
    CONSTRAINT fk_DaThich_Phim FOREIGN KEY(idPhim) REFERENCES tb_Phim(ID),
)
GO

----------------------------------------------------------------------------
--RÀNG BUỘC TOÀN VẸN
----------------------------------------------------------------------------
--tb_DanhMuc
ALTER TABLE tb_DanhMuc ADD CONSTRAINT uni_DanhMuc UNIQUE(DanhMuc)
GO

--tb_QuocGia
ALTER TABLE tb_QuocGia ADD CONSTRAINT uni_QuocGia UNIQUE(QuocGia)
GO

--tb_Phim 
ALTER TABLE tb_Phim ADD CONSTRAINT chk_ThoiLuong CHECK(ThoiLuong>0)
--ALTER TABLE tb_Phim ADD CONSTRAINT uni_TenPhim_en UNIQUE(TenPhim_en)
--ALTER TABLE tb_Phim ADD CONSTRAINT uni_TenPhim_vi UNIQUE(TenPhim_vi)
ALTER TABLE tb_Phim ADD CONSTRAINT chk_NamPhatHanh CHECK(NamPhatHanh BETWEEN 1990 AND YEAR(GETDATE()))
GO

--tb_TheLoai
ALTER TABLE tb_TheLoai ADD CONSTRAINT uni_TheLoai UNIQUE(TheLoai)
GO

--tb_DaoDien
ALTER TABLE tb_DaoDien ADD CONSTRAINT uni_TenDaoDien UNIQUE(TenDaoDien)
GO

--tb_DienVien
ALTER TABLE tb_DienVien ADD CONSTRAINT uni_TenDienVien UNIQUE(TenDienVien)
GO

--tb_TaiKhoan
ALTER TABLE tb_TaiKhoan ADD CONSTRAINT chk_SDT CHECK(LEN(SDT)=10)
ALTER TABLE tb_TaiKhoan ADD CONSTRAINT uni_Username UNIQUE(Username)
GO


----------------------------------------------------------------------------
--NHẬP DỮ LIỆU
----------------------------------------------------------------------------
INSERT INTO tb_TaiKhoan(Username, Password, LoaiTK)
VALUES
('admin','78fa4c6895a1c781b353bf79f166aa9a', 1)
GO

INSERT INTO tb_DanhMuc(DanhMuc, ThuTu)
VALUES
(N'Đang cập nhật', NULL),
(N'Phim Lẻ', 1),
(N'Phim Bộ', 2)
GO

INSERT INTO tb_TheLoai(TheLoai, ThuTu)
VALUES
(N'Đang cập nhật', NULL),
(N'Nổi bật', 1),
(N'Hành động', 2),
(N'Hài hước', 3),
(N'Hình sự', 4),
(N'Cổ trang', 5),
(N'Võ thuật', 6),
(N'Hoạt hình', 7),
(N'Chiến tranh', 8),
(N'Tình cảm', 9),
(N'Phiêu lưu', 10),
(N'Kinh dị', 11),
(N'Kịch tính', 12),
(N'Viễn tưởng', 13),
(N'Tâm lý', 14),
(N'Thần thoại',15),
(N'Âm nhạc',16),
(N'TV Show',17),
(N'Khoa Học',18)
GO

INSERT INTO tb_QuocGia(QuocGia, ThuTu)
VALUES
(N'Mỹ', 1),
(N'Anh', 2),
(N'Việt Nam', 3),
(N'Hàn Quốc', 4),
(N'Hồng Kông', 5),
(N'Trung Quốc', 6),
(N'Đài Loan', 7),
(N'Thái Lan', 8),
(N'Nhật Bản',9),
(N'Ấn Độ',10),
(N'Pháp',11),
(N'Khác',12)
GO

INSERT INTO tb_DienVien(TenDienVien)
VALUES
(N'Đang cập nhật'),
(N'He Zhang'),(N'Jonny Siew'),(N'Xiaoming Xuan'),(N'Tianxiang Yang'),
(N'Bành Vu Yến'),(N'Tân Chỉ Lôi'),(N'Vương Ngạn Lâm'),
(N'Park Seo Joon'), (N'Ahn Sung Ki'), (N'Woo Do Hwan'), ('Choi Woo Sik'),
(N'Josue Aguirre'), (N'Lynn Collins'), (N'Rigo Sanchez'),
(N'Joel Mchale'),(N'Kevin James'), (N'Lulu Wilson'),
(N'Seung won Cha'), (N'Tae-goo Eom'), (N'Yeo-bin Jeon'),
(N'Ivanna Sakhno'), (N'Mariam Sulakadze'),(N'Olga Sulzhenko'),
(N'Châu Tấn'), (N'Trần Khôn'),(N' Trần Vỹ Đình'),
(N'Esom'),(N' Kwon Hae Hyo'), (N'Lee Kwang Soo'), (N'Park Chul Min'), (N'Shin Ha kyun'),
(N'Bawriboon Chanreuang'),(N' Margie Rasri Balenciaga'), (N'Maythinee Booranasiri'), (N'Toni Rakkaen'),
(N'Isaac Lobé-Lebel'), (N'Jérémy Prévost'),(N'Lior Chabbat'),
(N'Lục Thụ Minh'), (N'Quan Trí Bân'), (N'Tấn Tùng'),
(N'Jang Dong Gun'), (N'Seo Tae-hwa'), (N'Yu Oh-seong'),
(N'Lưu Đức Hòa'),(N'Lưu Thanh Vân'), (N'Nghê Ni'),
(N'Seung-ah Moon'),(N'Yoo Ah In'), (N'Yoo Jae Myung'),
(N'Hứa Thi Thần'), (N'Lưu Ngật Thần'), (N'Trương Dương'),
(N'Jin Seon -kyu'), (N'Kim Tae Ri'), (N'Song Joong Ki'),
(N'Huang Zhizhong'), (N'Jiang Wu'), (N'Oho Ou'),
(N'Mã Lộ'),(N'Sa Dật'), (N'Tống Tiểu Bảo'),
(N'Ayub Tsingiev'), (N'Igor Petrenko'), (N'Ivan Shakhnazarov'),
(N'Lưu Hạo Nhiên'), (N'Nghê Đại Hồng'), (N'Vương Bảo Cường'),
(N'Anastasios Soulis'), (N'Johannes Kuhnke'), (N'Nanna Blondell'),
(N'Luis Ángel Jaramillo'), (N'Pablo Gama Iturrarán “Mago Gamini”'), (N'Verónica Alva'),
(N'Callum Maloney'),(N'Dermot Magennis'),(N' Ian Coppinger'),
(N'Chang Chen'),(N'Janine Chang'),(N'Yōsuke Eguchi'),
(N'Ahmed el-Sakka'),(N'Amir Karara'),(N'Ghadah Abdulrazeq'),(N'Scott Adkins'),
(N'Deng Lun'),(N'Mark Chao'),(N'Wang Ziwen'),
(N'Brandon Auret'),(N'Reine Swart'),(N'Thandi Puren'),
(N'Bo Huang'),(N'Gang Wu'),(N'Gong Li'),
(N'Nam Sênh'),(N'Nghiêm Thế Khôi'),(N'Tạ Miêu'),(N'Trịnh Văn Lâm'),
(N'Javier Gutiérrez'),(N'Karra Elejalde'),
(N'Đồ Thiệu Tồn'),(N'Nguyên Đằng'),(N'Tuấn Thiến'),
(N'Chantavit Dhanasevi'),(N'Sammy Cowell'),(N'Tanawat Wattanaputi'),
(N'Cát Trạch'),(N'Nghiêm Ngật'),(N' Tần Dương'),
(N'Alexis Victor'),(N'Kylian Trouillard '),(N'Marie Chevalot'),
(N'Joan Chen'),(N'Tan Zhuo'),(N'Xiao Yang'),
(N'Jamie Bell'),(N'Jayssolitt'),(N'Ruby Rose'),
(N'Evgniy Romantsov'),(N'Mariya Lisovaya'),(N'Viktoriya Agalakova'),
(N'Jaeden Martell'),(N' Lia McHugh'),(N'Riley Keough'),
(N'Madeleine Martin'),(N'Moa Gammel'),(N'Trine Wiggen'),
(N'Cao Quáng Trạch'),(N'Hàn Thông Thông'),(N'Xuyết Ni'),
(N'Huỳnh Hiểu Minh'),(N'Lý Băng Băng'),
(N'Camille Sullivan'),(N'Devon Sawa'),(N'Summer H. Howell'),
(N'Eduardo Moscovis'),(N'Maisa Silva'),(N'Marcelo Médici'),
(N'Kentaro Ito'),(N'Rina Kawaei'),(N'Ryota Katayose'),
(N'James Rolleston'),(N' Lawrence Makoare'),(N'Te Kohe Tuhaka'),
(N'Cheng Rexen'),(N'Kha Giai Yến'),(N'Vương Dương Minh'),
(N'Chong ok Bae'),(N'Hye-Sun Shin'),(N'Jin-Yeong Park'),
(N'Annabelle Wallis'),(N'Mel Gibson'),(N'Michelle Yeoh'),
(N'Hứa An Thực'),(N'Lý Khang Sinh'),(N'Trần Tuyết Chân'),
(N'AJ Bowen'),(N'Joe Swanberg'),(N'Sharni Vinson'),
(N'Jade-Angelica Fromento'),(N'Mario Maurer'),(N'Supakorn Kitsuwon'),
(N'Megumi Ohara'),(N' Wasabi Mizuta'),(N'Yumi Kakazu'),
(N'Châu Bách Hào'),(N'Liên Thi Nhã'),(N'Tạ Thiên Hoa'),
(N'Emma Stone'),(N'Leslie Mann'),(N'Nicolas Cage'),(N'Peter Dinklage'),(N'Ryan Reynolds'),
(N'Dennis To'),
(N'Ben Whishaw'),(N' Gwendoline Christie'),(N'Tilda Swinton'),
(N'Chayanat Jamsai'),(N'Ingkarat Damrongsakkul'),(N'Suchart Chankaeo'),(N'Supatat Opas'),
(N'Dale Carley'),(N'Eréndira Ibarra'),(N'Tenoch Huerta'),
(N'Ahmet Atalay'),(N'Glen Baggerly'),(N'Mashood Alam'),
(N'Diao Biao'),(N'Mike'),(N'Wang Li Yu'),
(N'Karlee Perez'),(N'Mario Van Peebles'),
(N'Atsushi AraiKen Aoki'),(N'Kohei Fukuyama'),(N'Yo Aoi'),
(N'Cheney Chen'),(N'Kris Wu'),
(N'Bành Ngu Khư'),(N'Đới An Na'),(N'Trịnh Tháp Cương'),
(N'Aksel Hennie'),(N'Jean Reno'),
(N'Adam Bessa'),(N'Is haq Elias'),(N'Suhail Dabbach'),
(N'Chutimon Chuengcharoensukying'),(N'Sunny Suwanmethanont'),
(N'Petchtai Wongkamlao'),(N'Suthep Pongam'),(N'Thierry Mekwattana'),(N'Yingyong Yodbuangam'),(N'Yuenyong Opakul'),
(N'Bobby Deol'),
(N'Brennley Brown'),(N'Noah Kaye Bentley'),(N'Zach Callison'),
(N'Caren Pistorius'),(N'Gabriel Bateman'),(N'Russell Crowe'),
(N'Hannah Quinlivan'),(N'Shawn Dou'),(N'Wang Xueqi'),
(N'Kaaris'),(N'Lannick Gautry'),(N'Stanislas Merhar'),
(N'Kiera Allen'),(N'Sarah Paulson'),(N'Sara Sohn'),
(N'Hugh Jackman'),(N'Zach Galifianakis'),(N'Zoe Saldana'),
(N'Darby Camp'),(N'Judah Lewis'),(N'Kurt Russell'),
(N'Gerald W. Jones III'),(N'Gregory Diaz IV'),(N'Jaden Michael'),
(N'Dương Dương'),(N' Mẫu Kỳ Di Nhã'),(N'Thành Long'),
(N'America Young'),(N'Erica Lindbeck'),(N'Ritesh Rajan'),
(N'Benedetta Porcaroli'),(N'Edoardo Leo'),(N'Vittoria Puccini'),
(N'Héctor Illanes'),(N'Ximena Romo'),
(N'Paisarnkulwong Vachiravit'),(N'Phiravich Attachitsataporn'),(N'Timethai Plangsilp'),
(N'Đại Tượng'),(N'Tiểu Liên Sát'),(N'Vương Tiêu Thiến'),
(N'Chen Fei'),(N'Katrina C'),(N'Wei Ni'),
(N'Khương Bành'),(N' Trình Mộ Hiên'),(N'Vu Thượng Hú'),
(N'Clara Kovacic'),(N'Kera OBryon'),(N'Strange Dave'),
(N'Andy Nyman'),(N' Martin Freeman'),(N'Paul Whitehouse'),
(N'Connie Nielsen'),(N'Dougray Scott'),(N'Hermione Corfield'),(N'Olwen Fouere'),
(N'Heinz Hoenig'),(N'Michael Herbig'),(N'Yvonne Catterfeld'),
(N'Cecilia Roth'),(N'Miguel Ángel Solá'),(N'Sofía Gala Castiglione'),
(N'Cư Văn Phái'),(N'Nhậm Chính Bân'),(N'Phạm Vĩ'),
(N'Akarin Akaranitimaytharatt'),(N' Kidakarn Chatkaewmanee'),(N'Sriphan Chunechomboon'),
(N'Chaos Lee'),(N'Zhang Ling'),(N'Leon Lee'),
(N'Ashley Bornancin'),(N' Byron Marc Newsome'),(N'Danny Fehsenfeld'),(N'Eric Saleh'),(N'Leslie L. Miller'),
(N'Kate Murphy'),(N' Miranda Tapsell'),(N'Ricard Cussó'),(N' Ross Noble'),
(N'Aintzane Krujeiras'),(N' Iñaki Beraetxe'),(N'Kiko Jáuregui'),
(N'Ariadna Gil'),(N'Raúl Mérida'),(N'Ruth Gabriel'),
(N'Danny Huston'),(N'Geoffrey Rush'),(N'Kate Bosworth'),
(N'Can Đình Đình'),(N'Hàn Đống')
GO

INSERT INTO tb_DaoDien(TenDaoDien)
VALUES
(N'Đang cập nhật'),
(N'Ji Zhao'),
(N'Lâm Siêu Hiền'),
(N'Kim Joo Hwan'),
(N'Max Pachman'),
(N'Jonathan Milott'),
(N'Park Hoon Jung'),
(N'Stanislav Kapralov'),
(N'Lý Uất Nhiên'),
(N'Yook Sang Hyo'),
(N'Kritsada Kaniwichaphon'),
(N'Tanguy de Kermel'),
(N'Vương Úy'),
(N'Kwak Kyung Taek'),
(N'Khâu Lễ Đào'),
(N'EuiJeong Hong'),
(N'Quách Ngọc Long'),
(N'Jo Sung Hee'),
(N'Guan Hu'),
(N'Tống Tiểu Bảo'),
(N'Aleksandr Aravin'),
(N'Đường Lý Lễ'),
(N'Alain Darborg'),
(N'Eric Cabello'),
(N'Christoph Lauenstein'),
(N'Su Chao-bin'),
(N'Peter Mimi'),
(N'Guo Jingming'),
(N'Darrell Roodt'),
(N'Peter Ho-Sun Chan'),
(N'Zhang Zhe'),
(N'Lluís Quílez'),
(N'Nasorn Panungkasiri'),
(N'Quách Kính Minh'),
(N'Jeremy Degruson'),
(N'Sam Quah'),
(N'Leopoldo Aguilar'),
(N'Dzhanik Fayziev'),
(N'Veronika Franz'),
(N'Joachim Hedén'),
(N'Trần Quốc Phú'),
(N'Shawn Linden'),
(N'Cris DAmato '),
(N'Masaaki Yuasa'),
(N'Toa Fraser'),
(N'Tiền Nhân Hào'),
(N'Sang-Hyun Park'),
(N'Joe Carnahan'),
(N'Shih-Han Liao'),
(N'Adam Wingard'),
(N'Kongkiat Khomsiri'),
(N'Kazuaki Imai'),
(N'Ally Wong'),
(N'Joel Crawford'),
(N'Li Liming'),
(N'Armando Iannucci'),
(N'Manussanun Pongsuwan'),
(N'Bernardo Arellano'),
(N'Ahmet Atalay'),
(N'Luo Le'),
(N'Isaac Florentine'),
(N'Shigeaki Kubo'),
(N'Đại Nghệ Lâm'),
(N'Ryuhei Kitamura'),
(N'Matthew Michael Carnahan'),
(N'Nawapol'),
(N'Pipat Jomkoh'),
(N'Atul Sabharwal'),
(N'Derrick Borte'),
(N'Simon West'),
(N'Olivier Marchal'),
(N'Aneesh Chaganty'),
(N'Chris Butler'),
(N'Clay Kaytis'),
(N'Osmany Rodriguez'),
(N'Stanley Tong'),
(N'Conrad Helten'),
(N'Francesco Amato'),
(N'Trình Đằng'),
(N'Santiago Alvarado Ilarri'),
(N'Phontharis Chotkijsadarsopon'),
(N'Lý Lăng Tiêu'),
(N'Zhou Zhong'),
(N'Hác Chiêu Hách'),
(N'Oliver Park'),
(N'Jeremy Dyson'),
(N'Neasa Hardiman'),
(N'Sven Unterwaldt Jr.'),
(N'Sebastián Schindel'),
(N'Jiang Liu'),
(N'Nareubadee Wetchakam'),
(N'Regina Welker'),
(N'Ricard Cussó'),
(N'Ángel Alonso'),
(N'Adolfo Martinez Perez'),
(N'Sngmoo Lee')
GO

INSERT INTO tb_Phim(TenPhim_en, TenPhim_vi, DanhMuc, QuocGia, NamPhatHanh, ThoiLuong, UrlPhim, MoTa)
VALUES
('New Gods: Nezha Reborn',N'Tân Phong Thần: Na Tra Trùng Sinh',2,6,2021,116, '//ok.ru/videoembed/2159348550396', N'Trong cuộc sống của một người giao hàng bình thường kiêm tín đồ đua xe, Na Tra chạm trán những kẻ thù cũ và phải tìm lại năng lực của mình để bảo vệ những người thân yêu.'),
('The Rescue',N'Đội Cứu Hộ Trên Không',2,6,2020,130, '//ok.ru/videoembed/2588175633062', N'Đội Cứu Hộ Trên Không</b> do Lâm Siêu Hiền đạo diễn, là bộ phim Hoa ngữ đầu tiên lấy đề tài cứu hộ trên biển, có vốn đầu tư “khủng” lên đến 700 triệu CNY. Ngoài các trang thiết bị cứu hộ được đặt hàng theo tiêu chuẩn châu Âu, đoàn làm phim còn mời các chuyên viên hậu trường Hollywood đảm nhận dàn dựng bối cảnh… Có thể nói, Đội Cứu Hộ Trên Không là bộ phim cứu hộ đẳng cấp quốc tế.'),
('Evil Expeller',N'Bàn Tay Diệt Quỷ',2,4,2021,130, '//ok.ru/videoembed/2159346977532', N'Sau khi bản thân bỗng nhiên sở hữu “Bàn tay diệt quỷ”, võ sĩ MMA Yong Hoo (Park Seo Joon thủ vai) đã dấn thân vào hành trình trừ tà, trục quỷ đối đầu với Giám Mục Bóng Tối (Woo Do Hwan) – tên quỷ Satan đột lốt người. Từ đó sự thật về cái chết của cha Yong Hoo cũng dần được hé lộ cũng như nguyên nhân anh trở thành “người được chọn”'),
('Beneath Us',N'Bẫy Ngầm',2,1,2019,86,'//ok.ru/videoembed/2307537439403',N'Giấc mơ Mỹ trở thành cơn ác mộng đối với một nhóm người lao động không có giấy tờ tùy thân được một cặp vợ chồng giàu có thuê. Những gì họ mong đợi là ngày lĩnh lương lớn nhất của họ biến thành một cuộc chiến sinh tồn đáng sợ.'),
('Becky',N'Kỳ nghỉ tồi tệ',2,1,2020,93,'//ok.ru/videoembed/2312060013227',N'Sau khi mất mẹ, Becky và cha cô đi du lịch đến ngôi nhà ven hồ của họ với cô bạn gái mới của bố cô và con trai của cô ấy. Becky cố gắng làm thân lại với cha cô trong chuyến đi này. Nhưng cuộc vui sớm trở nên tồi tệ khi những kẻ bị kết án đang trên đường chạy trốn, dẫn đầu bởi tên sát nhân Dominick tàn nhẫn, bất ngờ xâm nhập ngôi nhà.'),
('Night in Paradise',N'Đêm nơi thiên đường',2,4,2020,132,'//ok.ru/videoembed/2302839294635',N'Trốn trên đảo Jeju sau một bi kịch thảm khốc, tay xã hội đen chịu bất công và bị truy đuổi tìm được sự kết nối với một người phụ nữ, và cô cũng có những mặt tối riêng.'),
('Let It Snow',N'Đồi tuyết máu',2,1,2020,87,'//ok.ru/videoembed/2268868315819',N'Đồi Tuyết Máu kể về chuyến du lịch chết người của cô gái Mia và chồng sắp cưới. Trượt tuyết bất chấp lời can ngăn, cả hai không may lạc nhau rồi phải xoay xở sống sót giữa thời tiết khắc nghiệt. Còn xui xẻo hơn khi Mia rơi vào tầm ngắm một tên sát nhân có sở thích giết người mua vui rồi vùi xác họ dưới nền lạnh.'),
('The Yin Yang Master',N'Ân Dương Sư: Thị Thần Lệnh',2,6,2021,132,'//ok.ru/videoembed/2190649657961',N'Âm Dương Sư: Thị Thần Lệnh là phim cổ trang lấy bối cảnh thời phong kiến, khi yêu ma vẫn còn đang trà trộn vào thế giới của loài người. Một nhóm người am hiểu phép thuật có thể di chuyển lại giữa hai thái cực là dương giới và âm giới, tinh thông về những thứ huyền huyễn, tinh thông phép thuật, thậm chí còn có thể điều khiển và sai khiến ma quỷ – họ được gọi là Âm Dương Sư (Onmyoji).'),
('Inseparable Bros',N'Thằng Em Lý Tưởng',2,4,2019,114,'//ok.ru/videoembed/2234580404907',N'Bộ phim tâm lý, hài hước và tình cảm đặc biệt là tình anh em vô cùng gắn kết của Se Ha và Dong-gu. Cả hai đều mang trong người những khuyết điểm khiến họ không thể sống một cuộc đời bình thường. Kẻ mất mẹ, người bị bỏ rơi, cả hai nương tựa nhau trong suốt hơn 20 năm gặp gỡ. Cho đến ngày họ gặp được Mi-hyun, cuộc sống của cả ba đã dần thay đổi khi Se Ha và Dong-gu buộc phải chia xa.'),
('Midnight University',N'Đại Học Ma',2,10,2016,113,'//ok.ru/videoembed/2206107568811',N'Đã bao giờ bạn thắc mắc rằng, liệu thế giới bên kia có còn điều gì ngoài muôn vạn hồn ma cùng những câu chuyện truyền miệng rùng rợn? Bạn có từng đặt giả thuyết hoang đường rằng ở đó cũng tồn tại một… lớp học? Nếu có thì sẽ như thế nào? Sẽ có bài kiểm tra chứ? Sẽ phải học những gì? Phim Midnight University xoay quanh nhân vật nữ chính là cô sinh viên tên Star – hotgirl của một trường đại học – cùng sáu người bạn cùng trường khác. Vì nhiều lý do, nhóm bạn buộc phải tham gia lớp học đêm nằm ở phòng Zero (vốn được sinh viên toàn trường xem là “lãnh địa” của những “đồng học” nhưng đã chết trước khi kịp tốt nghiệp), tạm gọi là một “lớp học ma ám” vô cùng đáng sợ. Cũng vì thế, bảy sinh viên “bất đắc dĩ” phải tham gia vào lớp học ở thế giới bên kia, mỗi tối vào lúc nửa đêm.'),
('Samsam',N'Sam Sam: Anh Hùng Nhí Tập Sự',2,11,2019,78,'//ok.ru/videoembed/2206019488427',N'Nhóc tì siêu quậy Samsam có tất cả mọi thứ mà bao đứa trẻ trên hành tinh Sam đều mơ ước: bố mẹ là hai siêu anh hùng nổi tiếng, học tập ở một ngôi trường danh giá chuyên đào tạo các thế hệ siêu nhân tương lai, thậm chí Samsam còn có hẳn một đĩa bay riêng để vi vu khắp nơi khắp chốn. Thế nhưng, cậu bé lại không có chút siêu năng lực nào, hoàn toàn khác biệt với tất cả các thành viên trong gia đình cũng như bạn bè đồng trang lứa. Bố mẹ lo lắng, bè bạn trêu ghẹo, Samsam bắt đầu hành trình tới hành tinh Marth bí ẩn cùng người bạn mới Mega, quyết tâm tìm kiếm sức mạnh ẩn tiềm của bản thân mình.'),
('Knights Of Valour',N'Thanh Long Uyển Nguyệt Đao',2,6,2021,80,'//ok.ru/videoembed/2155866557033',N'Thanh Long Yển Nguyệt Đao là phim Cổ Trang – Võ Thuật kể về trận chiến Mạch thành, Quan Vũ bị Phan Chương của quân Ngô giết chết, Thanh Long Yển Nguyệt Đao cũng bị cướp đi từ đó. Quan Hưng, con trai của Quan Vũ may mắn sống sót một lòng báo thù cho cha, khổ luyện võ công chỉ vì muốn đoạt thần binh về. Hai năm sau, Lưu Bị chuẩn bị thảo phạt nước Ngô, lệnh cho các tướng lĩnh trẻ tuổi do Quan Hưng đứng đầu hợp thành một đội bí mật thực thi nhiệm vụ phá hoại trung khu phòng ngự của quân Ngô. Quan Hưng đã vượt qua vô vàn trở ngại, hiểm nguy chồng chất, bất ngờ phát hiện âm mưu của quân Ngô, xoay vần thế cục cuộc chiến trong thời khắc mấu chốt. Cuối cùng, Quan Hưng quyết chiến với kẻ thù giết cha Phan Chương ở thủy trại, liệu Thanh Long Yển Nguyệt Đao sẽ về tay ai đây?'),
('Friend',N'Bạn Bè',2,4,2001,118,'//ok.ru/videoembed/2152507837033',N'Bộ phim kể về cuộc sống của bốn người bạn thời thơ ấu: Joon-seok, trưởng nhóm có cha là một trùm băng đảng quyền lực; Dong-su, có cha là người đảm nhận; chú hề lớp Jung-ho; và Sang-taek, một học sinh gương mẫu. Khi còn nhỏ, chúng chơi cùng nhau và bán những bức ảnh khiêu dâm. Ở trường trung học, họ trở nên say mê với ca sĩ chính của một ban nhạc nữ cùng tuổi. Joon-seok mời ban nhạc đến một bữa tiệc tại nhà của anh ấy, nơi Sang-taek nhận được nụ hôn đầu tiên từ ca sĩ chính, Jin-sook.'),
('Shock Wave 2',N'Sóng Dữ 2',2,5,2020,121,'//ok.ru/videoembed/2148838541929',N'Sóng Dữ 2 kể rằng một nơi nào đó ở Hồng Kông xảy ra vụ án đánh bom, chuyên gia gỡ bom về hưu Phan Thừa Phong (Lưu Đức Hoa) bởi vì hôn mê ở hiện trường nên bị cảnh sát hoài nghi có liên quan đến vụ việc. Phan Thừa Phong sau khi tỉnh lại chỉ có thể vừa chạy trốn vừa tìm chân tướng, nhưng Đổng Trác Văn (Lưu Thanh Vân) và bạn gái cũ Bàng Linh (Nghê Ni) lại kể cho anh nghe hai đoạn quá khứ không giống nhau. Những vụ án đánh bom có kế hoạch liên tiếp xảy ra, chân tướng ngày càng khó bề phân biệt.'),
('Voice of Silence',N'Khi Im Lặng Cất Lời',2,4,2020,99,'//ok.ru/videoembed/2192087190187',N'Chàng trai câm Tae In cùng với gã đàn ông trung niên Chang Bok là những người chuyên dọn dẹp xác chết cho một tổ chức tội phạm. Một ngày nọ, họ nhận được nhiệm vụ trông giữ một “đơn hàng” đặc biệt với thù lao hậu hĩnh. Tuy nhiên, người thuê họ lại đột ngột qua đời khiến 2 người mắc kẹt vào những rắc rối không ngờ tới.'),
('Tai Chi Hero',N'Trương Tam Phong 2: Thái Cực Thiên Sư',2,6,2020,66,'//ok.ru/videoembed/2139446250089',N'Trương Tam Phong 2: Thái Cực Thiên Sư xoay quanh Trương Tam Phong khi còn trẻ. Câu chuyện bắt đầu từ âm mưu nguy hiểm của Tu La Mộ, hắn nhận lệnh từ sư phụ tìm kiếm Huyền Hạp Bát Cực. Tam Phong và sư muội Yên Nhi cố gắng lật tẩy bọn chúng, nhưng lại vô tình bị gày bẫy khiến sư phụ Long Hỏa chân nhân bị giết. Tam Phong may mắn được Khưu đạo trưởng cứu chữa, một lòng trả thù.'),
('Space Sweepers',N'Con Tàu Chiến Thắng',2,4,2021,137,'//ok.ru/videoembed/2133936704105',N'Con Tàu Chiến Thắng nói về năm 2092, Trái đất gần như không thể ở được. Tập đoàn UTS xây dựng một ngôi nhà quỹ đạo mới cho nhân loại mô phỏng các quá trình tự nhiên trên Trái đất; tuy nhiên, chỉ một số được chọn mới được phép lên và trở thành công dân UTS, trong khi những người còn lại trên Trái đất hít thở không khí ô nhiễm và chiến đấu để nuôi sống gia đình của họ. Dưới sự hướng dẫn của người sáng lập và Giám đốc điều hành UTS, James Sullivan, công ty đang nỗ lực hướng tới việc biến sao Hỏa trở thành Trái đất mới, trồng cây biến đổi gen trên hành tinh và biến nó thành một môi trường thân thiện với con người.Để điều chỉnh dân số theo quỹ đạo và để mắt đến những người không phải là công dân, UTS quản lý họ thông qua một bộ quy tắc và thuế nghiêm ngặt. Nhiều người không phải công dân từ khắp nơi trên thế giới làm công việc quét không gian, thu thập các mảnh vỡ không gian trôi nổi trên quỹ đạo Trái đất và bán nó cho công ty để tồn tại. Cốt truyện kể về một phi hành đoàn gồm những người quét không gian và con tàu của họ, Victory.'),
('The Eight Hundred',N'Bát Bách',2,6,2021,142,'//ok.ru/videoembed/2132885572201',N'Bát Bách kể về cuộc chiến Trung – Nhật năm 1937, mà bối cảnh chính diễn ra ở thành phố Thượng Hải dựa trên sự kiện lịch sử có thật ở đại lục.'),
('Dreams of Getting Rich',N'Giấc Mộng Giàu Sang',2,6,2021,128,'//ok.ru/videoembed/2177697581739',N'Cốt truyện kéo dài gần 30 năm, kể về câu chuyện của cậu bé nghèo vùng Đông Bắc “Tiểu Bảo” theo “Anh Hai” cùng làng đến Thâm Quyến làm giàu, hai người đàn ông quyết tâm kiếm tiền lập nghiệp. Sự xuất hiện bất ngờ của cậu bé bị bỏ rơi Thiên Ý đã làm thay đổi cuộc đời họ. Cả hai trở thành cha bất đắc dĩ và gặp Mã Lộ, một phụ nữ lạnh lùng lớn tuổi. Từ đây bắt đầu cuộc đời đầy niềm vui nước mắt của họ.'),
('Decision: Liquidation',N'Quyết Định Thanh Trừng',2,12,2018,96,'//ok.ru/videoembed/2594889403046',N'Quyết Định Thanh Trừng nói về Bazgaev – một kẻ cực đoan, tàn bạo, chịu trách nhiệm cho các cuộc tấn công khủng bố dẫn đến cái chết của hàng trăm thường dân, trong số đó có học sinh. Một nhóm nhân viên an ninh đang theo dõi và tiêu diệt hắn ta. Phim dựa trên một câu chuyện có thật.'),
('Shao Lin Shi Zhi De Bao Chuan Qi',N'Truyền Kỳ Đắc Bảo Ở Thiếu Lâm Tự',2,8,2021,93,'//ok.ru/videoembed/2175658166955',N'Tây Môn Đắc Bảo là một ông chủ quán trọ không có chí, hàng ngày cùng huynh đệ đóng giả sơn tặc còn mình đóng giả tướng quân cứu người nhằm dẫn khách tới khách trạm của mình. Không may một ngày màn kịch bị vạch trần, lại thêm một ông hòa thượng già cản trở việc làm ăn. Họa không chỉ thế, Thứ sử Linh Châu là Hà Kiêu lại giết khâm sai rồi đổ tội cho Đắc Bảo nhằm có được bảo đồ kho báu. Trong một đêm, Đắc Bảo trở thành tội phạm truy nã, con trai mất mạng, vì để trả thù Đắc Bảo đã theo hòa thượng học võ công. Từ đây mở ra một cuộc hành trình đắc đạo đầy ly kỳ.'),
('Red Dot',N'Chấm Đỏ',2,12,2021,126,'//ok.ru/videoembed/2124941429353',N'Red Dot là một bộ phim kinh dị kể về sau khi Nadja mang thai, cô và bạn trai cố gắng hàn gắn lại mối quan hệ bằng cách đi du ngoạn đến miền bắc Thụy Điển, nhưng chuyến đi lãng mạn của họ nhanh chóng biến thành một cơn ác mộng'),
('Xico Journey',N'Hành Trình Của XICO',2,12,2020,85,'//ok.ru/videoembed/2164137659051',N'Cô bé nọ cùng cậu bạn thân và một chú chó quyết cứu một ngọn núi khỏi công ty muốn khai thác vàng. Nhưng chìa khóa lại chẳng ở đâu xa, khi đã có chú chó thân thiết Xico.'),
('Luis and the Aliens',N'Luis Và Nhóm Bạn Ngoài Hành Tinh',2,12,2018,85,'//ok.ru/videoembed/2163458706091',N'Luis Và Nhóm Bạn Ngoài Hành Tinh là bộ phim hoạt hình cực kỳ hài hước và vui nhộn cho cả nhà vào Tết này. Chú nhóc tinh nghịch và 3 người bạn mới ngoài hành tinh sẽ khuấy đảo màn ảnh rộng đảm bảo sẽ gây tiếng cười tuyệt đỉnh cho người xem.'),
('Silk',N'Sợi Chỉ Huyền Bí',2,7,2010,108,'//ok.ru/videoembed/2115503458921',N'Ở Đài Bắc , một nhóm thợ săn ma trả tiền cho một người làm nghề camera tự do để chụp ảnh những nơi đang tìm kiếm hoạt động huyền bí. Từ những âm thanh của sự vật, những nỗ lực trước đây đã không thành công. Người cầm máy đang chụp ảnh và lần này là hình ảnh một cậu bé trong một căn phòng dường như trống rỗng. Nhóm thợ săn ma rất hồi hộp và tự mình điều tra thêm.Họ mang theo một sĩ quan cảnh sát, một tay súng sắc bén và một đầu đọc môi để được trợ giúp thêm trong cuộc điều tra nhằm nghiên cứu thêm về Ghost. Cán bộ có mẹ bị bệnh hôn mê, cơ thể đang phân hủy. Mặc dù viên cảnh sát từ chối đề nghị giúp đỡ trong giai đoạn đầu, anh ta chấp nhận vụ việc vì tò mò. Ở phía bên kia, giám đốc của toàn bộ chương trình này kêu gọi nhóm từ bỏ nghiên cứu của họ vì nó có vẻ vô giá trị và gây tốn kém cho chính phủ Nhật Bản. Nhóm nghiên cứu tiết lộ một khối từ tính có thể tự phân chia và thu nhận năng lượng dưới mọi hình thức. Khả năng giữ năng lượng của nó đến mức nó có thể chịu được lực của trọng lực và lơ lửng trong không khí. Giám đốc hiển nhiên đồng ý đề nghị hỗ trợ thêm.'),
('No Surrender',N'Không Đầu Hàng',2,12,2018,116,'//ok.ru/videoembed/2163040520875',N'Alexandria, Ai Cập. năm 1940. Ba thanh niên Ai Cập đến giúp đỡ một phụ nữ đang bị lính Anh tấn công. Một trong những người lính, cháu trai của thống đốc quân đội Alexandria của Anh, bị bắt và tống vào tù. Khi thống đốc Anh yêu cầu thả cháu trai của mình ra, nếu không quân đội Anh sẽ tấn công. Tướng Youssef al-Masrito, bảo vệ nhà tù của mình và bảo vệ người dân của mình, với một cương quyết: Không đầu hàng!'),
('The Yin Yang Master: Dream of Eternity',N'Âm Dương Sư: Tình Nhã Tập',2,6,2021,132,'//ok.ru/videoembed/2113843235433',N'Âm Dương Sư: Tình Nhã Tập là một bộ phim Viễn Tưởng – Võ Thuật kể về câu chuyện nhiều thế kỷ trước, một con quỷ Evil Serpent được sinh ra từ mong muốn của con người. Bốn bậc thầy từ bốn giáo phái khác nhau đã tập hợp lại với nhau để phong ấn con rắn trong Hoàng thành. Nhiều năm trôi qua, Four Guardians được xây dựng để ngăn chặn Ác ma Rắn thoát ra và tàn phá phần còn lại của thế giới. Kể từ đó, bất cứ khi nào Ác ma trỗi dậy, bốn chủ nhân khác nhau sẽ đi đến Hoàng thành để đánh thức Tứ vệ để bẫy con rắn. Với mối đe dọa của Ác ma rắn tăng một lần nữa, bốn chủ nhân khác nhau đến với nhau: Hongruo, Longye, Bo Ya và Qing Ming.</b>Qing Ming, đệ tử của Zhongxing, được gửi đến Hoàng thành sau khi sư phụ của anh qua đời và tôn xưng anh là Âm Dương Sư. Nghe theo lời chỉ dẫn của chủ nhân, anh mang theo thanh kiếm Fangyue, thứ mà chủ nhân của anh đã dùng để giết Ác ma Xà trong quá khứ. Khi đến nơi, anh gặp và đi nhầm chân với Bo Ya. Trong đêm đầu tiên ở lại, Sư phụ Hongruo bị một con quỷ tóc giết trong giấc ngủ. Hoàng hậu ra lệnh cho Công chúa Chang Ping điều tra cái chết của Hongruo, và cử một vị chủ nhân khác là He Shouyue thay thế cho Master Hongruo. Nhận thấy He Shouyue có nét giống Zhongxing kỳ lạ, Qing Ming đối mặt với anh ta. He Shouyue tiết lộ mình là Thần Hộ mệnh của Zhongxing, được cử đến để bảo vệ Hoàng hậu, và đang dần chết vì cái chết của Zhongxing.'),
('The Lullaby',N'Lời Ru Tử Thần',2,12,2018,86,'//ok.ru/videoembed/2161649584811',N'hloe bị choáng sau khi sinh đứa con đầu lòng. Tiếng khóc không ngừng của đứa con, cảm giác tội lỗi và hoang tưởng ngày một tăng làm cô ta rơi vào trạng thái trần cảm. Với nỗ lực cao để bảo vệ đứa con, Chloe lúc nào cũng nhìn thấy nguy hiểm kề cập. Cô bắt đầu nghe những âm thanh, tiếng ngân nga của bài hát ru thơ ấu và thấy một thực thể lạ xung quanh đứa con của cô. Bị thuyết phục bởi thực thể đó là thực, Chloe làm mọi cách bằng sức của mình để bảo vệ đứa con. Liệu cô ta bị ám bởi ác quỷ không?'),
('Duo Guan AKA Leap',N'Bước Nhảy Vọt',2,6,2020,134,'//ok.ru/videoembed/2111471290985',N'Bước Nhảy Vọt nói về sau 12 năm, đội tuyển bóng chuyền nữ Trung Quốc mới lại lọt vào trận chung kết Olympic. Những thăng trầm của đội tuyển bóng chuyền nữ Trung Quốc trong hơn 3 thập kỷ đã dần trôi đi.'),
('Xin Qiji 1162',N'Tân Khí Tật 1162',2,6,2020,110,'//ok.ru/videoembed/2156019780267',N'Năm 1161, khi mà vùng đất đại triều Tống bị chia cắt, nhân dân rơi vào cảnh khốn cùng, Tân Khí Tật cảm thấy bất mãn trước sự độc ác của chính quyền nên quyết tâm nuôi khát vọng thống nhất giang sơn xã tắc. Chiến tranh và sự áp lực đã đẩy cuộc sống của mọi người đã khó khăn lại càng thêm bi đát, tất cả cùng nhau hợp sức đòi lại công bằng, từ những cuộc khởi nghĩa nhân dân nhỏ lẻ và dần dần lớn mạnh. Khí Tật trải qua bao trận đánh, trở thành một tướng quân tài giỏi, niềm tự hào của dân tộc.'),
('Below Zero',N'Dưới Không Độ',2,12,2021,106,'//ok.ru/videoembed/2096017508969',N'Dưới Không Độ là một bộ phim hành động Tây Ban Nha nói về chuỗi tiêu đề cho thấy một người đàn ông trong khu rừng tối tăm tra tấn một người đàn ông khác để tìm thông tin, và chôn sống anh ta khi anh ta tuyên bố không biết vị trí của thi thể mất tích.</br>Vừa thay chiếc lốp bị thủng cho chiếc xe của mình, cảnh sát Martin đã chi tiết để lái một chuyến vận chuyển tù nhân vào ban đêm. Trên một con đường vắng vẻ, xe tải của họ bị chặn lại bởi một dải phân cách. Khi Montesino, sĩ quan cảnh sát hộ tống, rời khỏi chiếc xe tải bọc thép để đánh giá tình hình, anh phát hiện ra chiếc xe phi công của họ bên vệ đường và hai sĩ quan bên trong bị bắn chết. Sau đó, chính anh ta bị bắn bởi một tay súng bắn tỉa từ trong khu rừng tối, và sau đó anh ta không thể chịu đựng được nữa. Martin, người cảnh sát đang lái xe, sống sót và đi vào khoang tù nhân, nơi anh ta bị chế ngự bởi những kẻ bị kết án. Kẻ tấn công bên ngoài, Miguel, bước vào cabin của chiếc xe tải và thông qua hệ thống liên lạc nội bộ rằng anh ta đang truy lùng một tù nhân cụ thể. Không thể mở khoang chứa tù nhân an toàn, anh ta lái chiếc xe tải vào một hồ nước đóng băng.'),
('In My Heart',N'Khoảng Khắc Này Muốn Có Em',2,6,2020,102,'h//ok.ru/videoembed/2141086747307',N'Hai anh em A Lạc (Đồ Thiệu Tồn thủ vai) và A Nguyên (Nguyên Đằng thủ vai) là những con người rất yêu âm nhạc. Một đêm nọ, vì để có thể chơi thử một cây đàn piano đắt tiền hai anh em đã mạo hiểm đột nhập vào giảng đường của trường học.</br>Nhưng không ngờ trong lúc tránh bảo vệ tuần tra, hai anh em đã gặp phải một đám lưu manh. Sau khi xảy ra xô xát, A Nguyên đã lâm vào hôn mê. A Lạc trở nên suy sụp và tự trách bản thân, nhưng vì giấc mơ âm nhạc của hai anh em mà A Lạc vẫn cố gắng thực hiện nó. Nhưng cuộc đời của A Lạc đã bước sang trang mới khi gặp được Monster (Tuấn Thiến thủ vai). Câu chuyện của họ sẽ đi về đâu?'),
('My God! Father',N'Đừng Gọi Anh Là Bố',2,8,2020,104,'//ok.ru/videoembed/2141073902251',N'Đừng Gọi Anh Là Bố! xoay quanh mối quan hệ bất hòa giữa Got – một tay đua và người bố Prem. Một tai nạn xe hơi đưa anh trở về khoảng thời gian bố anh vẫn còn trẻ và vô tình trở thành bạn chí cốt của bố. Thông qua chuyến xuyên không kì diệu này, anh có cơ hội gặp lại được mẹ và hiểu hơn về câu chuyện đằng sau tính cách cộc cằn của bố.'),
('The End Of Endless Love',N'Nếu Âm Thanh Không Ghi Nhớ',2,6,2020,100,'//ok.ru/videoembed/2134410791595',N'Bộ phim kể về câu chuyện tình giữa chàng trai nhút nhát và cô gái mang chứng trầm cảm. Tân Đường có khả năng điều khiển âm thanh. Khi anh đang quét mộ cho cha mẹ, anh đã tình cờ gặp Cát Trạch, một cô gái đang lứa tuổi học sinh và có vẻ không mấy thân thiện với những hành vi của cô ở nghĩa trang. Đổi lại thì Cát Trạch cũng không hề ưa sự thờ ơ và lạnh Lùng của Tân Đường. Thông qua các tình tiết nhỏ nhặt, hai con người không nhìn thấy mặt của nhau cuối cùng lại có mối liên kết không thể phá vỡ.'),
('Bigfoot Family',N'Gia Đình Chân To Phiêu Lưu Ký',2,1,2020,90,'//ok.ru/videoembed/2133050067627',N'Gia Đình Chân To Phiêu Lưu Ký tiếp nối phần phim Bố Tớ Là Chân To kể về cuộc phiêu lưu thú vị đến vùng đất Alaska với mong muốn truyền tải thông điệp ý nghĩa về môi trường sau khi Adam và Bố trở thành những gương mặt được truyền thông săn đón. Trong lúc đang dốc sức để mang lại những điều tuyệt vời cho Alaska, họ đã phát hiện một âm mưu tàn phá môi trường. Liệu gia đình Chân To có ngăn chặn được âm mưu độc ác này và bảo vệ vùng đất?'),
('Sheep Without a Shepherd',N'Ngộ Sát',2,6,2019,112,'//ok.ru/videoembed/2083122973289',N'Ngộ Sát là một bộ phim kinh dị Trung Quốc do TVHAY thực hiện thuyết minh kể về Li Weijie, vợ Ayu của mình và hai cô con gái của họ Pingping và An-an, là một Trung Quốc gia đình sống ở miền bắc Thái Lan kể từ 17 năm qua. Weijie điều hành một cửa hàng cung cấp dịch vụ internet và là một người đam mê điện ảnh, thích xem phim trinh thám và có kiến ​​thức sâu sắc về đề tài này. Họ xuất thân từ một gia đình trung lưu.</br>Một ngày nọ, Pingping muốn tham gia một trại hè và tại trại, cô đã gặp suchat, con trai của một ứng cử viên chính trị và cảnh sát trưởng. Tại trại hè, Pingping đã bị xâm phạm bởi suchat và sau đó anh ta đã ghi lại các đoạn video quay cảnh anh ta thực hiện các hành vi khiêu dâm để điều khiển Pingping.'),
('Cranston Acedemy: Moster Zone',N'Học Viện Quái Vật: Du Học Sinh',2,1,2020,85,'//ok.ru/videoembed/2123039771307',N'Bộ phim kể về Danny – một thiên tài 15 tuổi và Liz – con gái của một nhà khoa học nổi tiếng. Danny luôn bị cô lập trong chính ngôi trường mà cậu theo học vì trí thông minh của mình. Về phía Liz, cô luôn cố gắng vượt qua cái bóng của cha mình để được coi là một thiên tài theo đúng nghĩa. Khi Danny bất ngờ được trao học bổng tại Học viện Cranston – một trường nội trú bí mật, nơi Liz đang là học sinh đứng đầu, họ dần trở thành đối thủ của nhau. Trong một lần chứng minh bản thân, Danny vô tình mở cánh cổng đến một chiều không gian khác và giải phóng hàng loạt quái vật. Để cứu lấy ngôi trường và sự an toàn của tất cả mọi người, Liz phải đặt sự ganh đua sang một bên và giúp Danny cùng với giáo sư Mothman vượt qua các sinh vật nguy hiểm.'),
('Cosmoball',N'Quái Thú Sao Hoả',2,12,2020,118,'//ok.ru/videoembed/2073527650921',N'Quái thú sao hỏa – Cosmoball là bộ phim thuộc thể loại anh hùng không gian 3D của Nga được phát hành năm 2020. Bộ phim do đạo diễn Dzhanik Fayziev chịu trách nhiệm chỉ đạo đồng viết kịch bản, bộ phim lấy cảm hứng từ tác phẩm viễn tưởng kinh điển của thế giới, dựa trên loạt phim hoạt hình Galactik Football, với sự tham gia sản xuất của kênh truyền hình Russia-1.</br>Bộ phim Quái Thú Sao Hỏa lấy bối cảnh tương lai, hậu khải huyền ở một thành phố tại trái đất, khi mà cuộc chiến tranh giữa các thiên hà đã làm cho nơi này trở thành khô cằn và đầy bệnh dịch. Để cứu lấy trái đất, thủ lĩnh của hội Nghiên cứu của hội đồng ngân hà đã tạo một con tàu khổng lồ với hình dáng của một cây hoa bồ công anh, bên trong là một sân vận động lớn, để tổ chức các giải đấu Cosmoball, để chuẩn bị cho cuộc chiến với kẻ tội phạm nguy hiểm nhất dải ngân hà. Và những vận động viên cuối cùng cũng sẽ là những người bảo vệ cho người dân trái đất khi chẳng may chiến tranh nổ ra. Số phận của trái đất cũng phụ thuộc vào cuộc chiến cuối cùng này'),
('The Lodge',N'Nhà Nghỉ Quỷ Ám',2,12,2019,108,'//ok.ru/videoembed/2070409185897',N'Nhà Nghỉ Quỷ Ám là một bộ phim kinh dị tâm lý.Cốt truyện của nó theo sau một người mẹ kế sắp trở thành người, một mình với hai đứa con của hôn phu, bị mắc kẹt tại nhà nghỉ nông thôn của họ trong lễ Giáng sinh . Ở đó, cô và những đứa trẻ trải qua một số sự kiện không thể giải thích được dường như có liên quan đến quá khứ của cô.</br>Laura Hall chết do tự tử sau khi chồng cũ Richard thông báo với cô rằng anh dự định kết hôn với Grace Marshall, một người phụ nữ mà anh gặp khi đang nghiên cứu cuốn sách về một giáo phái Cơ đốc cực đoan . Lớn lên trong giáo phái, Grace là người sống sót duy nhất trong vụ tự sát hàng loạt của họ , do cha cô dẫn đầu. Cái chết của Laura tàn phá cô và các con của Richard, Aiden tuổi teen và Mia trẻ tuổi.</br>Sáu tháng sau, Richard thông báo rằng họ sẽ trải qua Giáng sinh với Grace tại nhà nghỉ xa xôi ở Massachusetts của gia đình để tìm hiểu nhau. Aiden và Mia đã khám phá ra quá khứ của Grace, bao gồm cả đoạn phim quay về giáo phái, cho thấy những người theo đạo đã khuất mặc áo lụa màu tím với băng keo trên miệng đọc “tội lỗi”. Tại nhà nghỉ, những đứa trẻ tỏ ra thù địch với Grace và từ chối những nỗ lực gắn kết với cô ấy, ngay cả sau khi Richard quay trở lại thành phố vì nghĩa vụ công việc. Cảm giác khó chịu của Grace thêm vào bởi sự phong phú của các hình tượng Công giáo trong cabin, điều này khiến cô gặp ác mộng về cha mình. Sau khi bị quở trách vì xem cô tắm, Aiden chuẩn bị cho Grace một tách ca cao.'),
('Breaking Surface',N'Mắc Kẹt Dưới Đáy Đại Dương',2,1,2020,82,'//ok.ru/videoembed/2069169703529',N'Breaking Surface – Mắc Kẹt Dưới Đáy Đại Dương thuộc thể loại hồi hộp, kinh dị của đạo diễn Joachim Hedén kể về câu chuyện của hai chị em với chuyến du ngoạn dưới đại dương sai lầm của họ. Với thời lượng 82 phút, đạo diễn Joachim Hedén đã mang đến những tình tiết hồi hộp và gay cấn.</br>Phim bắt đầu bằng đoạn mở đầu ngắn gọn, tạo nên tiền đề cho mối quan hệ giữa hai chị em Ida (Moa Gammel) và Tuva (Madeleine Martin); cả hai đã thử lặn xuống mặt hồ trước nhà nhưng chị gái Ida đã nổi lên và kêu gào sự cứu giúp vì em gái của mình đã bị chìm. Dù đã cứu được đứa bé lên nhưng cô bé đã mất mội thời gian để tỉnh lại, bà mẹ đã quát mắng Ida vì sự vô ý có thể dẫn tới tử vong.'),
('The Unbeatable',N'Hữu Phỉ: Phá Tuyết Trảm',2,6,2021,91,'//ok.ru/videoembed/2115186133675',N'Hữu Phỉ: Phá Tuyết Trảm Lý Cẩn Dung vì báo thù mà đến Kim Lăng, bắt tay cùng Cam Đường tiên sinh Chu Dĩ Đường, trảm Bắc Đẩu diệt gian tướng bảo vệ thái bình cho Nam Bắc Triều.'),
('The Message',N'Phong Thanh',2,6,2009,118,'//ok.ru/videoembed/2065030908521',N'Bối cảnh phim diễn ra tại Nam Kinh vào năm 1942 khi lãnh thổ Trung Quốc đang bị quân đội Đế quốc Nhật Bản xâm chiếm. Sau một loạt vụ ám sát nhằm vào quan chức thân Nhật, viên tướng Takeda đã tung tin tức giả hòng dụ bắt một nhóm người bị tình nghi là nội gián về ngôi biệt thự Cầu Trang để tra hỏi. Trò chơi “mèo vờn chuột” căng thẳng bắt đầu khi một điệp viên cộng sản Trung Quốc có mật danh “Lão Quỷ” cố gắng đưa tin tình báo ra ngoài để bảo vệ tổ chức của mình…<br/>Trong nhóm người bị tình nghi có Cố Hiểu Mộng, Lý Ninh Ngọc và Đại úy Ngô Chí Quốc. Sở trưởng Vương Điền Hương cho đặt máy nghe lén trong từng phòng để theo dõi từng người. Quân Nhật còn phát những mẫu giấy thông tin cho nhóm người bị tình nghi và tất cả nhân viên công chức khắp nơi để họ ghi lại thông tin cá nhân cho quân Nhật gửi về sở chỉ huy điều tra thêm. Sau đó có một nhân viên công chức tên Bạch Tiểu Niên bị quân Nhật bắt về ngôi biệt thự để tra khảo và bị đánh đập đến chết.'),
('Hunter Hunter',N'Thợ Săn Kẻ Giết Người',2,1,2020,93,'//ok.ru/videoembed/2049111624297',N'Joseph Mersault (Sawa), vợ Anne (Sullivan) và con gái Renee (Howell) sống ở vùng hoang dã hẻo lánh của Canada, kiếm được ít lợi nhuận bằng nghề đánh bẫy lông thú. Joseph huấn luyện Renee háo hức cách làm mồi và bẫy các loài động vật khác nhau, trong khi Anne ở nhà và chăm sóc cabin, giặt quần áo và lấy nước.<br/>Sự yên tĩnh của họ bị đe dọa khi một con sói nguy hiểm bắt đầu ăn những con vật bị mắc kẹt dọc theo đường lông của họ. Bất chấp sự phản đối của Anne, Joseph rời khỏi căn nhà gỗ để theo dõi con sói và loại bỏ mối đe dọa.<br/>Sau một ngày dài trong vùng hoang dã theo dõi con sói với Renee, Joseph tìm thấy dấu vết mới và gửi con gái của mình trở về nhà vì lo lắng cho sự an toàn của cô bé. Tuy nhiên, Joseph vẫn tiếp tục săn con sói một mình. Cuối cùng anh tình cờ gặp một nhóm phụ nữ trẻ đã chết – bị tàn sát dã man, khỏa thân và sắp xếp trong một vòng tròn nghi lễ.'),
('Double Dad',N'Có Tận Hai Người Cha',2,12,2021,105,'//ok.ru/videoembed/2086030936747',N'Trong khi mẹ đi vắng, một thiếu nữ trốn khỏi cộng đồng hippie nơi mình đang sống và dấn thân vào một cuộc phiêu lưu thay đổi cuộc đời để tìm ra bố cô là ai.'),
('Ride Your Wave',N'Lướt Sóng Cùng Em',2,9,2019,95,'//ok.ru/videoembed/2029255658089',N'Lướt Sóng Cùng Em kể về mối tình bi kịch của Hinako và chàng lính cứu hỏa Minato. Khi tình yêu vừa chớm thì Minato gặp tai nạn lướt sóng và vĩnh viễn ra đi'),
('The Dead Lands',N'Vùng Đất Tử Thần',2,12,2014,107,'//ok.ru/videoembed/2498512816806',N'Sau khi bộ tộc của mình bị sát hại bởi một tên phản bội. Hongi, con trai thủ lĩnh của người Maori, phải đứng lên đi tìm kẻ đã giết cha mình và mang về sự bình yên và tôn vinh cho những người thân đã mất. Hy vọng để Hongi tìm ra kẻ thù là băng qua các vùng đất chết đầy nguy hiểm…'),
('Abyssal Spide',N'Nộ Hải Cuồng Chu',2,7,2020,107,'//ok.ru/videoembed/2011075250793',N'Tiền Nhân Hào là đạo diễn, nhà sản xuất phim kỳ cựu của điện ảnh Đài Loan, ông có trong tay khá nhiều tác phẩm chất lượng và được đánh giá cao về tài năng. Mad Spider Sea chính là dự án mới nhất của ông, được phát hành trực tuyến vào đầu tháng 10 và nhanh chóng nhận sự quan tâm đặc biệt từ phía khán giả. Nó mang một phong cách khá khác với điện ảnh xứ Đài, nhưng vẫn giữ được cái chất riêng, và rất đáng để theo dõi với những ai yêu thích dòng phim phiêu lưu viễn tưởng.<br/>Phim có tựa đề việt là Nộ Hải Cuồng Chu, với sự tham gia của dàn diễn viên chất lượng như: Vương Dương Minh, Cheng Rexen, Kha Giai Yến, Lý Khang Sinh, Liren Li,…Mặc dù không có gương mặt nào quá sáng giá nhưng tất cả đều giàu kinh nghiệm và có khả năng diễn xuất tốt. Nội dung tác phẩm xoay quanh nhân vật A Kiệt và hành trình chống trọi với loài nhện biển nguy hiểm.<br/>Từng nằm trong đội cứu hộ, nhưng vì một phút mất bình tĩnh mà A Kiệt gián tiếp hại chết đội trưởng, khiến các thành viên trong đội vô cùng tức giận. Sau đó, anh chán nản với cuộc sống, rượu chè và không quan tâm đến gia đình. Cho đến một ngày, anh nhận ra mình đang đi sai hướng và quyết định xin thuyền trường cho ra khơi cùng. Cả đội ra biển trong đúng đêm cơn bão đổ về, họ bắt được rất nhiều cá nhưng bất ngờ phải đối mặt với loài nhện khổng lồ, chúng rất độc và tấn công mọi người.'),
('Innocence',N'Trắng Án',2,4,2020,110,'//ok.ru/videoembed/2011075381865',N'Trắng Án kể về câu chuyện của một luật sư tên là Jung In cố gắng chứng minh sự vô tội của mẹ cô và khám phá những bí mật của một ngôi làng nhỏ với sự giúp đỡ của thị trưởng địa phương. Mẹ của cô, Hwa Ja bị buộc tội giết người sau khi rượu gạo bị đầu độc trong đám tang của chồng cô, nhưng bà đang bị mất trí nhớ và không thể tự vệ.'),
('Annabelle Wallis',N'Đẳng Cấp Boss',2,1,2021,100, '//ok.ru/videoembed/2011075316329',N'Boss Level xoay quanh một sĩ quan lực lượng đặc biệt Clive Ventor – người đã nghỉ hưu bị mắc kẹt trong một vòng lặp thời gian không bao giờ kết thúc vào ngày ông qua đời.'),
('The Rope Curse 2',N'Thòng Lọng Ma 2',2,7,2020,105,'//ok.ru/videoembed/2048924388011',N'Sau một nghi lễ thanh tẩy thất bại, vị pháp sư đầy mâu thuẫn cố giúp đỡ một nhà ngoại cảm trẻ và cô độc có người dì bị một ác quỷ quyền năng nhập xác.'),
('Youre Next',N'Nạn Nhân Tiếp Theo',2,2,2011,95,'//ok.ru/videoembed/2465334102694',N'Nạn Nhân Tiếp Theo tập trung vào 1 cuộc đoàn tụ gia đình đầy chết chóc khi họ trở thành mục tiêu của một tên sát nhân đeo mặt nạ. Hy vọng duy nhất của họ là Erin, cô bạn gái của một thành viên trong gia đình…'),
('Khun Phaen Begins',N'Huyền Thoại Bắt Đầu',2,8,2019,111,'//ok.ru/videoembed/2465231800998',N'Khun Phaen: Huyền Thoại Bắt Đầu được thực hiện dựa trên tác phẩm văn học dân gian lớn nhất Thái Lan là Khun Chang Khun Phaen. Câu chuyện xoay quanh nhân vật chính tên Kaew (Mario Maurer), không nơi nương tựa lẫn kí ức, anh trở thành một trên trộm vặt lang thang khắp nơi, và rồi nhiều biến cố xảy ra khiến anh dần tìm lại ký ức. Khun Phaen: Huyền Thoại Bắt Đầu hứa hẹn sẽ là một là bộ phim đầy kịch tính về những ngày trước khi trở thành “siêu anh hùng” huyền thoại Khun Phaen của Kaew.'),
('Doraemon The Movie: Nobita New Dinosaur',N'Nobita Và Những Người Bạn Khủng Long',2,9,2020,110,'//ok.ru/videoembed/2019759295147',N'Tình cờ tìm thấy trứng khủng long khi tham gia hoạt động khảo cổ, Nobita dùng bảo bối thần kỳ “khăn trùm thời gian” của Doraemon khiến chúng nở ra một cặp khủng long song sinh và đặt tên là Kyu và Myu. Và rồi cùng với Doraemon và nhóm bạn thân, Nobita đưa Kyu và Myu trở về 66 triệu năm trước.'),
('The Infernal Walker',N'Vô Gian Hành Giả: Sinh Tử Tiềm Hành',2,5,2020,90,'//ok.ru/videoembed/2442736896678',N'Vô Gian Hành Giả: Sinh Tử Tiềm Hành nói về hai sĩ quan cảnh sát, một bên đen và một bên trắng, mỗi người vì con đường công lý của riêng mình, lao vào cuộc đối đầu sinh tử.'),
('The Croods: A New Age',N'Gia Đình Croods: Kỷ Nguyên Mới',2,1,2020,95,'//ok.ru/videoembed/2002469259947',N'Từ một gia đình tiền sử sống trong hang với nỗi lo sợ thường trực về thế giới nguy hiểm bên ngoài, nhà Croods đã tự tin bước khỏi vùng an toàn của mình, tiến tới việc làm chủ nhiều phát minh quan trọng.'),
('Ip Man Kung Fu Master',N'Diệp Vấn: Bậc Thầy Võ Thuật',2,6,2019,85,'//ok.ru/videoembed/1953747569257',N'IP MAN: KUNG FU MASTER quay trở lại những ngày đầu của Ip trước Cách mạng Cộng sản năm 1949. Ip, do Dennis To thể hiện lần thứ ba với vai võ sĩ nổi tiếng kèm cặp Lý Tiểu Long, lúc đó là đội trưởng cảnh sát bị buộc tội giết người của một tên cướp tàn nhẫn nhưng danh dự, và được nhắm mục tiêu báo thù bởi đứa con gái nguy hiểm của mình. Bị buộc phải từ bỏ lực lượng, Ip cũng sớm phải đối mặt với sự xuất hiện của quân đội Nhật Bản tại Quảng Châu.<br/>Trong thời gian làm đội trưởng cảnh sát ở Phật Sơn, Ip Man là mục tiêu của một băng đảng xã hội đen báo thù ngay khi quân đội Nhật Bản xâm lược khu vực.'),
('Personal History of David',N'Cuộc Đời Của David',2,1,2019,120,'//ok.ru/videoembed/1993941650091',N'Một tác phẩm mới mẻ và đặc sắc về kiệt tác bán tự truyện của Charles Dickens, Lịch sử cá nhân của David Copperfield, lấy bối cảnh vào những năm 1840, ghi lại cuộc đời của nhân vật tiêu đề mang tính biểu tượng của nó khi ông điều hướng một thế giới hỗn loạn để tìm vị trí khó nắm bắt của mình trong đó.'),
('Haunted School',N'Trường Học Ma Ám',2,8,2016,95,'//ok.ru/videoembed/1993941584555',N'Trường học là nơi bao nhiêu câu chuyện xảy ra, học sinh đến và đi, chỉ có phòng học và sân trường còn ở lại. Có những người rời trường với những ký ức khó quên, có những người mãi mãi không bao giờ quên những gì mình đã từng trải qua ở đó. Một ngày đẹp trời, nhóm học sinh nọ trốn lớp và tụ tập kể cho nhau nghe những câu chuyện kinh dị, mỗi câu chuyện càng lúc càng trở nên đáng sợ hơn. Khi những nhân vật ma quái bước từ chuyện vào đời thật, ma quỷ bắt đầu xuất hiện đeo bám các học sinh và trường học không còn là nơi an toàn nữa.'),
('Bernardo Arellano',N'Thế Lực Hắc Ám',2,12,2020,81,'//ok.ru/videoembed/1943292742249',N'Trên đường tìm kiếm em gái, gã tội phạm đang chạy trốn tìm kiếm câu trả lời tại một khách sạn tồi tàn, gặp gỡ vị khách nham hiểm và tán tỉnh cô hầu phòng bí ẩn.'),
('The Cure',N'Phương Thuốc Thần Kỳ',2,1,2020,36,'//ok.ru/videoembed/1939059509865 ',N'Trong tương lai gần, một loại virus bí ẩn đã xâm chiếm một phần lớn dân số thế giới, nhiễm độc, nó giết chết vật chủ trong vòng một ngày. Không có cách chữa khỏi vĩnh viễn, chỉ có một loại huyết thanh tạm thời có thể đặt lại sau mỗi 24 giờ.<br/.Lực lượng đặc biệt của lính đánh thuê, con gái nhỏ của Noah là một trong những người bị nhiễm bệnh. Khi một phương pháp chữa trị vĩnh viễn bị một tổ chức khủng bố bí ẩn đánh cắp khỏi phòng thí nghiệm tối mật, Noah được tuyển dụng để lấy lại nó và cuối cùng cứu sống con gái mình.'),
('Zhao Zilong',N'Triệu Tử Long',2,6,2020,93,'//ok.ru/videoembed/1936964061801',N'Chiến thần ngày xưa đã trở lại với con đường trở thành một anh hùng. Năm xưa Triệu Vân vì bị bỏ rơi nên cảm thấy chán nản, quyết định lên núi sống ẩn cư. Nhiều năm sau ông được Lưu Bị mời tham gia vào trận chiến, vì giữ lời hứa với mình mà Triệu Vân đồng ý chiến đấu vì Lưu Bị. Sau cùng ông cảm kích trước lòng nhân từ của Lưu Bị.'),
('Seized',N'Giải Cứu Con Tin',2,1,2020,85,'//ok.ru/videoembed/1934595328617',N'Cựu đặc nhiệm bị lôi cuốn vào cuộc đấu tranh của các tổ chức tội phạm mà anh ta đã tham chiến trong nhiều năm. Một trong những nhóm muốn sử dụng đặc nhiệm làm vũ khí và bắt cóc con trai ông ta. Giờ đây, để cứu con mình, anh phải tiêu diệt 3 băng đảng mafia nguy hiểm nhất'),
('High And Low The Worst',N'Cuộc Chiến Băng Đảng: Kẻ Tồi Tệ Nhất',2,9,2019,125,'//ok.ru/videoembed/1931096427113',N'Trường trung học Demon được chia thành một hệ thống bán thời gian và hệ thống toàn thời gian, Yoshiki Murayama là người đứng đầu trường trung học Demon và Kaede Hanaoka có tham vọng vào thế giới toàn thời gian để thách thức Murayama một ngày nào đó.'),
('Legend of Ravaging Dynasties 2',N'Tích Tước 2',2,6,2020,129,'//ok.ru/videoembed/1923222932073',N'Một đứa trẻ mồ côi trở thành đệ tử của một phù thủy quyền năng và bị lôi kéo vào một cuộc xung đột lớn hơn giữa giới tinh hoa phép thuật trên thế giới.'),
('Prophesy of fire',N'Cửu Hà Long Xà',2,6,2020,90,'//ok.ru/videoembed/1963643308715',N'Lời nguyền về Hỏa Thần lan rộng trong thành khiến lòng dân hoang mang. Thần trộm Tiền Bất Nhị, đạo tặc Trương Lập Tam và y tá Tô Diệp bị ép cuốn vào trong, bắt đầu tìm kiếm chân tướng sự việc. Trong quá trình tìm hiểu họ bị Ma Cổ Đạo truy giết, bất ngờ tìm được gợi ý để cứu người dân ở chỗ tiên cá. Họ phải chạy đua với thời gian, vén màn bí ẩn về tượng Hỏa Thần trong truyền thuyết…'),
('The Doorman',N'Người Gác Cửa',2,1,2020,97,'//ok.ru/videoembed/1918113417833',N'Nữ quân nhân Ali trở về quê hương New York để hồi phục những chấn thương trong thời gian phục vụ quân ngũ. Được người thân nhờ làm gác cửa tại một căn biệt thự chứa nhiều tài sản quý giá, Ali vô tình trở thành người bảo vệ nơi này trước kế hoạch tấn công được tính toán kỹ lưỡng của một nhóm trộm chuyên nghiệp.'),
('Mosul',N'Thành Phố Mosul',2,1,2020,102,'//ok.ru/videoembed/1912530012777',N'Sau khi được một nhóm vũ trang vô tổ chức ở Iraq cứu mạng, một cảnh sát trẻ gia nhập nhóm và cùng sát cánh trong cuộc chiến chống lại ISIS tại thành phố Mosul bị tàn phá'),
('Happy Old Year',N'Tháng Năm Hạnh Phúc Ta Từng Có',2,8,2019,113,'//ok.ru/videoembed/1911674047081',N'Một người phụ nữ trở về nhà sau ba năm sống ở Thụy Điển, và bắt đầu dọn dẹp nhà cửa bằng cách loại bỏ những thứ không cần thiết.'),
('The Protector',N'Siêu Vệ Sĩ Sợ Vợ',2,8,2019,83,'//ok.ru/videoembed/1951195138731',N'Kampon là một nhân viên bảo vệ ngân hàng. Mặc dù vậy, ông có một quá khứ “bá đạo” khi từng là một đặc vụ giỏi hoạt động trong các chiến dịch của chính phủ, nên ông có kĩ năng rất tuyệt vời về chiến đấu trừ kĩ năng “đối phó với vợ”. Trong một lần đi làm về, khi đang dừng mua mỳ về cho vợ ở nhà, ông bị cuốn vào một âm mưu ám sát tổng thống nước láng giếng của Thái Lan. Lúc này, Kampon phải thể hiện kĩ năng của mình để bảo vệ tổng thống và bảo vệ món mỳ mà vợ đang đón đợi ở nhà.'),
('Class of 83',N'Khoá 83',2,10,2020,99,'//ok.ru/videoembed/1903500331625',N'Một cảnh sát anh hùng phải đối mặt với hình phạt khi Hiệu trưởng học viện cảnh sát quyết định trừng phạt bộ máy quan liêu tham nhũng và các đồng minh tội phạm của nó bằng cách đào tạo năm cảnh sát sát thủ chết người. Nhưng, giống như tất cả các kế hoạch tốt, nó chỉ hoạt động được một thời gian cho đến khi ngọn lửa mà anh ta đốt lên có nguy cơ thiêu rụi ngôi nhà của chính anh ta.<br/>Class of 83, dựa trên cuốn sách của nhà báo tội phạm hàng đầu Hussain Zaidi, lấy bối cảnh ở Bombay vào những năm 1980 khi thế giới ngầm siết chặt thành phố đang trở nên khó phá vỡ. Hàng chục thanh niên thất nghiệp do cuộc đình công đang diễn ra đã bị dụ gia nhập các băng đảng địa phương, và mối quan hệ giữa các chính trị gia quyền lực và các thủ lĩnh băng nhóm tội phạm khiến cảnh sát khó giải quyết vấn đề. Với bối cảnh này là bối cảnh, bộ phim kể về một người huấn luyện viên đã biến thành cảnh sát có tư tưởng, người đã biến năm học viên trở thành những chuyên gia chạm trán'),
('Dragons Rescue Riders: Huttsgalor Holiday',N'Biệt Đội Giải Cứu Rồng: Lễ Hội Ở Huttsgalor',2,1,2020,46,'//ok.ru/videoembed/1945822104235',N'Tuyết rơi báo hiệu lễ Ô-đin-du — ngày lễ trao tặng của người Viking! Nhưng thời tiết oái oăm có thể phá hỏng kỳ nghỉ lễ truyền thống, trừ phi Biệt đội giải cứu ra tay.'),
('Unhinged',N'Kẻ Cuồng Sát',2,1,2020,90,'//ok.ru/videoembed/1900200659561',N'Rachel là một bà mẹ đơn thân, trong dịp tình cờ cô đã gặp rắc rối với gã đàn ông bí ẩn. Tưởng chừng mọi việc chỉ là hiểu lầm, nhưng tình hình trở nên nghiêm trọng khi người đàn ông kia bắt đầu truy sát Rachel và những người thân của cô.'),
('Skyfire',N'Lửa Trời',2,6,2019,93,'//ok.ru/videoembed/1894896175721',N'phim xoay quanh hành trình chiến đấu chống lại sự phun trào đáng sợ của núi lửa tại Đảo Thiên Hỏa. Được biết đến là một nơi vô cùng đẹp và điểm đến lý tưởng nhưng ít người biết rằng sự nguy hiểm tiềm tàng khi nó nằm trong vành đai núi lửa Pacific. Trong lần nhà địa chất Lý Hiểu Mộng cùng nhóm nghiên cứu đến đây để phát triển hệ thống giám sát núi lửa thì bất ngờ gặp phải sự cố. Núi lửa hoạt động trở lại và họ phải nhanh chóng tìm cách nếu muốn sống sót trở về.'),
('Rogue City',N'Thành Phố Băng Đảng',2,12,2020,116,'//ok.ru/videoembed/1891663481449',N'Lấy bối cảnh ở Marseille , một băng nhóm cảnh sát chống băng đảng với những phương pháp phi chính thống điều tra một vụ xả súng tại hộp đêm cùng với một đơn vị đối thủ lâu năm.'),
('Run',N'Trốn Chạy',2,1,2020,89,'//ok.ru/videoembed/1891663415913',N'Tuyệt tác từ đội ngũ biên kịch, sản xuất & đạo diễn của SEARCHING. Liệt nửa người và mắc phải nhiều chứng bệnh mãn tính từ lúc lọt lòng, cuộc sống của Chloe đến tận năm 17 tuổi chỉ xoay quanh mẹ mình Diane và gần như bị cô lập với thế giới bên ngoài. Đến khi phát hiện ra bí mật khủng khiếp mẹ đang cố gắng che giấu, Chloe biết mình cần phải trốn chạy khỏi cái lồng vô hình đã giam giữ bản thân bấy lâu nay.'),
('Missing Link',N'Hành Trình Bí Ẩn',2,1,2019,95,'//ok.ru/videoembed/1889064192617',N'Vào năm 1886, Sir Lionel Frost, một nhà điều tra chật vật về các sinh vật thần thoại, đã liên tục tìm kiếm các sinh vật khác nhau để nghiên cứu và thông báo về sự hiện diện của chúng trên thế giới, điều này sẽ cho phép ông được chấp nhận vào “Hiệp hội những người vĩ đại”, do Đối thủ của Sir Lionel, Lord Piggot-Dunceby. Lionel nhận được một lá thư thừa nhận sự hiện diện của một Sasquatch , thỏa thuận với Piggot-Dunceby sẽ cho phép anh ta tham gia vào hội nếu anh ta chứng minh được rằng sinh vật đó là có thật.<br/>Lionel đi đến Tây Bắc Thái Bình Dương, cuối cùng tình cờ gặp Sasquatch trong một khu rừng . Sau khi gọi anh ta là “Mr. Link”, Lionel được Sasquatch cho biết rằng anh ta thực sự là người đã gửi bức thư. Ông Link yêu cầu sự giúp đỡ của Lionel trong việc tìm kiếm người thân của ông, người Yetis , trên dãy Himalaya. Lionel đồng ý giúp anh ta nhưng không biết rằng Piggot-Dunceby đã thuê một thợ săn tiền thưởng tên là Willard Stenk để theo dõi Lionel và giết anh ta, đảm bảo rằng các quan điểm bảo thủ ủng hộ chủ nghĩa đế quốc của xã hội vẫn không bị phản đối.'),
('The Christmas Chronicles',N'Biên Niên Sử Giáng Sinh',2,1,2018,104,'//ok.ru/videoembed/1930614606507',N'Sau khi vô tình làm hỏng xe trượt tuyết của ông già Noel, cậu anh trai và cô em gái dành cả đêm để cứu vãn đêm Giáng sinh cùng Thánh Nick hiểu biết, thẳng thắn.'),
('Vampires vs The Bronx',N'Ma Cà Rồng Ở Quận Bronx',2,1,2020,85,'//ok.ru/videoembed/1886322100841',N'Ba đứa trẻ can đảm ở quận Bronx – nơi đang chuyển mình nhanh chóng – vô tình phát hiện âm mưu hiểm ác nhằm rút cạn sinh lực cộng đồng yêu dấu của họ.'),
('Vanguard',N'Người Tiên Phong',2,6,2020,107,'//ok.ru/videoembed/2360359914150',N'Phim kể về việc tổ chức bảo an Cấp tiên phong do Thành Long đứng đầu nhận nhiệm vụ bảo vệ thương nhân Thái Quốc Lập và con gái Fareeda. Từ đây, họ phải chống lại Bắc cực lang – đơn vị lính đánh thuê, giải cứu con tin và ngăn chặn âm mưu khủng bố.'),
('Barbie Princess Adventure',N'Công Chúa Phiêu Lưu',2,1,2020,73,'//ok.ru/videoembed//1921063848619',N'Cùng bạn mới ở vương quốc mới, Barbie học được ý nghĩa của việc được là chính mình khi hoán đổi vị trí với cô công chúa giống hệt cô trong cuộc phiêu lưu tràn tiếng ca.'),
('18 Presents',N'18 Món Quà',2,12,2020,114,'//ok.ru/videoembed/1878517746281',N'Phim được lấy cảm hứng từ nhân vật thần thoại Jiang Ziya (Khương Tử Nha), một chỉ huy của quân đội thiên giới. Anh được giao nhiệm vụ trục xuất Hồ Ly chín đuôi, kẻ đang đe dọa sự tồn tại của tất cả mọi người. Khi phát hiện ra cuộc đời của Hồ Ly chín đuôi có liên kết với linh hồn của một cô gái vô tội, anh phải đối mặt với một quyết định đầy thử thách – làm theo ý trời hay tự mình tìm ra con đường đi đến chính nghĩa.'),
('Legend of Deification',N'Khương Tử Nha: Nhất Chiến Phong Thần',2,6,2020,109,'//ok.ru/videoembed/1874949704297',N'Phim được lấy cảm hứng từ nhân vật thần thoại Jiang Ziya (Khương Tử Nha), một chỉ huy của quân đội thiên giới. Anh được giao nhiệm vụ trục xuất Hồ Ly chín đuôi, kẻ đang đe dọa sự tồn tại của tất cả mọi người. Khi phát hiện ra cuộc đời của Hồ Ly chín đuôi có liên kết với linh hồn của một cô gái vô tội, anh phải đối mặt với một quyết định đầy thử thách – làm theo ý trời hay tự mình tìm ra con đường đi đến chính nghĩa.'),
('The Day of the Lord',N'Ngày Của Chúa',2,12,2020,93,'//ok.ru/videoembed/1872748022377',N'Trong bộ phim kinh dị này, vị linh mục đã nghỉ hưu bị ám ảnh bởi tội lỗi của mình bị kéo trở lại bóng tối khi một người bạn thỉnh cầu ông giúp đỡ đứa con gái bị quỷ ám.'),
('Pee Nak 2',N'Ngôi Đền Kỳ Quái 2',2,8,2020,114,'//ok.ru/videoembed/2444605262502',N'Balloon & First sau khi không chịu nổi cảnh tu hành nên đã quyết định hoàn tục trở về cuộc sống thường nhật. Nhưng họ đâu biết rằng, lí do mong muốn hoàn tục lại chính là thứ khiến họ bị ám bởi một lời nguyền.'),
('Mr. Miao',N'Diệu Tiên Sinh',2,6,2020,88,'//ok.ru/videoembed/1911056239275',N'Tại sao phải giết người tốt, cứu người xấu? Vì muốn tìm thấy câu trả lời mà Đinh Quả và sư phụ Lương Diễn bắt đầu hành trình truy tìm tung tích hoa Bỉ Ngạn, vừa gian nan vừa hiện thực…'),
('The Blade of Wind',N'Trảm Phong Đao',2,6,2020,86,'//ok.ru/videoembed/1910682880683',N'Vì bị cuốn vào cơn sóng gió của “người rắn”, ba vị nữ hiệp cùng nhau lên đường, sát cánh kề vai trong chuyến phiêu lưu đầy mạo hiểm để tìm ra chân tướng. Ba người cát bụi dặm trường, vung đao chém Bất Lương Soái, nào ngờ đâu Bất Lương Soái thật sự lại là một kẻ khác…'),
('Poison Valley Bride',N'Vân Tịch Truyện: Độc Cốc Tân Nương',2,6,2020,72,'//ok.ru/videoembed/1910246476459',N'Độc phi thiên tài xông vào Dược Quỷ Cốc, giải trừ được cổ độc nghìn năm và so tài với tân nương không bao giờ già! Tần vương Long Phi Dạ và vương phi Hàn Vân Tịch tinh thông cách dùng độc cùng nhau phá giải muôn trùng khó khăn để xông được vào Quỷ Cốc. Ở đây họ đã phát hiện được truyền thuyết về “tân nương cổ độc”. Tân nương cổ độc lợi dụng cổ độc để hút máu người, gìn giữ tuổi xuân, chờ đợi tướng quân trở về cưới mình. Hàn Vân Tịch thi thố khả năng dùng độc với Tân nương cổ độc, bị dồn vào chỗ chết mới tìm được cách phá giải độc thuật, đập tan âm mưu!'),
('A Night of Horror: Nightmare Radio',N'Đêm Kinh Hoàng: Đài Phát Thanh Ác Mộng',2,2,2019,104,'//ok.ru/videoembed/1862739626601',N'Phim Đêm Kinh Hoàng: Đài Phát Thanh Ác Mộng – A Night Of Horror: Nightmare Radio (2020) nói về Rod, DJ đài phát thanh, tổ chức một chương trình có chủ đề kinh dị nổi tiếng với những câu chuyện khủng bố cho những người nghe háo hức. Khi anh nhận được những cuộc gọi đáng báo động từ một đứa trẻ kinh hoàng, mọi thứ bắt đầu cảm thấy khó chịu.'),
('Ghost Stories',N'Chuyện Ma Lúc Nửa Đêm',2,1,2017,98,'//ok.ru/videoembed/1892907879083',N'Ghost Stories nói về Giáo sư Phillip Goodman bắt tay vào một cuộc tìm kiếm ly kỳ sau khi ông vấp phải một tập tin bị mất từ rất lâu, trong đó chứa những thông tin chi tiết về ba trường hợp “bị ám” không thể giải thích được.'),
('Sea Fever',N'Trùng Quỷ Đại Dương',2,1,2019,94,'//ok.ru/videoembed/1892719135403',N'Trong một chuyến tàu đánh cá đến Tây Ireland, phi hành đoàn bị mắc kẹt lênh đênh giữa biển. Những tưởng không còn gì nguy hiểm hơn, họ lại phải đối mặt với một loài ký sinh trùng đang phát triển ngay chính trong nguồn nước sinh hoạt. Những cơn hoảng loạn, sự nghi ngờ và xung đột bắt đầu xảy ra khiến tình hình càng lúc càng tệ hơn..'),
('Tabaluga',N'Chú Rồng Dũng Cảm',2,12,2019,86,'//ok.ru/videoembed/1892368714411',N'Bộ phim kể về một chú rồng xanh nhỏ dũng cảm, là hoàng tử của xứ Greenland. Với sự giúp đỡ của công chúa băng Lilli xinh đẹp, chú rồng không chỉ tìm thấy ngọn lửa và sức mạnh của tình yêu mà còn thành công cứu lấy vùng đất Greenland khỏi tay người tuyết độc tài xấu xa, kẻ đang rắp tâm chiếm lấy thế giới. Bộ phim hứa hẹn sẽ mang lại nhiều xúc động, đậm chất giải trí cho các em thiếu nhi cũng như các lứa tuổi khác. Bộ phim được chuyển thể từ series hoạt hình truyền hình rất nổi tiếng tại Đức.'),
('The Crimes That Bind',N'Tội Ác Gia Đình',2,12,2018,100,'//ok.ru/videoembed/1850873481833',N'Trong bộ phim ngắn gọn này, Alicia, do Cecilia Roth thủ vai , mẹ của Daniel, do Benjamín Amadeo thủ vai, bị mù quáng bởi tình yêu vô điều kiện của cô dành cho đứa con trai 35 tuổi, và thậm chí không thể nghĩ đến khả năng anh ta có thể phạm tội. hành hung, hãm hiếp, rình rập và bạo lực đối với phụ nữ. Bộ phim bắt đầu với cảnh Alicia tiếp đón những người bạn trên mạng xã hội của mình trong căn hộ của họ ở Buenos Aires , Argentina tại một trong những khu phố sang trọng nhất của thủ đô, nơi cô sống với người chồng kỹ sư đã nghỉ hưu 70 tuổi, Ignacio, do Miguel Ángel Solá thủ vai., người giúp việc sống tại Gladys của cô, do Yanina Ávila thủ vai, và con trai 3 tuổi của Gladys, Santiago (Santi), người gọi Alicia là dì. Gladys có xuất thân khiêm tốn. Mẹ cô mất khi cô khoảng ba hoặc bốn tuổi và cô sống với cha mình, người đã bỏ rơi và bạo hành cô trong một khu rừng hẻo lánh. Cô trở thành một người hầu không được trả công cho người vợ thứ hai của cha mình và các anh chị em kế của cô cho đến những năm thiếu niên, khi cô trốn đến Buenos Aires với sự giúp đỡ của một người hàng xóm, nơi cô được Alicia thuê.'),
('Set Off',N'Hôm Nay Khởi Hành',2,6,2008,96,'//ok.ru/videoembed/1850873416297',N'Khi một chủ nhà hàng ở Síp quay trở lại Bắc Kinh để ký giấy ly hôn, người phụ nữ say rượu mà anh gặp phải đã gây ra một chuỗi những rắc rối.'),
('Low Season',N'Yêu Nhau Mùa "Ế"',2,8,2020,120,'//ok.ru/videoembed/1887581571755',N'Yêu Nhau Mùa Ế xoay quanh một cô gái có khả năng đặc biệt là nhìn thấy ma quỷ. Sau khi chia tay với bạn trai, cô cảm thấy mệt mỏi vì chốn thành thị náo nhiệt và quyết định rời khỏi đây để tìm một nơi ở ẩn . Cô kéo vali đến một khu nghỉ dưỡng xa xôi ở phía Bắc và vô tình gặp một chàng trai chuyên viết kịch bản. Cả hai cùng bắt đầu hành trình chạy trốn khỏi ma quỷ và dần dần cảm mến nhau.'),
('Dragon Hunting In The Western Regions',N'Vua Phiêu Lưu: Thợ Săn Rồng Tây Vực',2,6,2020,67,'//ok.ru/videoembed/1887601953451',N'Nội dung phim kể về Giang Lưu Hải và Tư Minh, hai chàng trai dùng tất cả tâm huyết để tìm kiếm kho báu của Long tộc. Nếu như Lưu Hải được mệnh danh là vua nhặt rác tại vùng xa mạc Tây Vực – Cửu Châu, làm tất cả mọi việc chỉ để kiếm thật nhiều tiền thì Tư Minh lại là gã mọt sách, anh đi theo Lưu Hải để thu thập chứng cứ thực tế và kho báu, viết ra cuốn sách ấp ủ nhiều năm qua. Cả hai kết hợp với công chúa Tây Vực, mỗi người có một lợi thế riêng, liệu họ có thể lấy được kho báu.'),
('Latte & the Magic Waterstone',N'Nhím, Sóc Và Viên Đá Thần Kỳ',2,12,2019,81,'//ok.ru/videoembed/1879653747371',N'Latte là một cô nhím nhỏ dễ thương, tự tin và tràn đầy sức sống. Latte rất thích kể chuyện mặc cho mọi người xung quanh có muốn nghe hay không. Một ngày nọ, những con vật trong khu rừng thức dậy, phát hiện ra rằng viên đá ma thuật đã bị mất và kẻ đánh cắp chính là Vua Gấu hung dữ với đôi vuốt nhọn. Latte tuyên bố chính cô sẽ lấy lại được viên đá để muôn loài không bị lời nguyền hạn hán mà tuyệt chủng.'),
('The Wishmas Tree',N'Giải Cứu Cây Ước Nguyện',2,12,2019,85,'//ok.ru/videoembed/1879677209259',N'Kerry, một cô nàng thú túi nhận được một điều ước và cô đã ước rằng cô có thể có một cây Ước Nguyện màu trắng. Thế nhưng, cách mà cô ước lại hoá sai và tệ hại hơn, nó làm đóng băng toàn bộ thành phố Sanctuary City của cô, còn đe dọa cuộc sống của tất cả những người sống ở đó.'),
('Elkano, lehen mundu bira',N'Elcano và Magellan: Hành Trình Bốn Bể',2,12,2019,90,'//ok.ru/videoembed/1879349791403',N'Chuyến thám hiểm của Elcano cùng các thủy thủ đoàn đầy vui nhộn và đối đầu với thách thức của thiên nhiên… Tháng 9 này cùng Elcano giương buồm ra khơi đến các vùng đất mới'),
('Rescue Under Fire',N'Cứu Hộ Trong Lửa',2,12,2017,93,'//ok.ru/videoembed/1832695958121',N'Phi hành đoàn của máy bay trực thăng y tế gặp tai nạn khi giúp đỡ một lực lượng liên hợp của quân đội Mỹ và Liên Hợp Quốc dưới quyền chỉ huy của Tây Ban Nha ở Afghanistan. Quân đội Tây Ban Nha chỉ có một đêm để tổ chức giải cứu phi hành đoàn và những người bị thương, nhưng điều tưởng chừng như thường lệ lại biến thành địa ngục một khi họ nhận được lệnh giải cứu chiếc trực thăng. Mọi thứ chỉ trở nên tồi tệ hơn khi trong đêm, một lượng lớn quân Taliban bắt đầu bao vây họ'),
('The Warriors Way',N'Con Đường Chiến Binh',2,4,2010,100,'//ok.ru/videoembed/1828868983401',N'Ở châu Á thế kỷ 19, Yang ( Jang Dong-gun ) là một chiến binh và là thành viên của tộc Sad Flutes, những sát thủ tàn ác nhất phương đông. Mục tiêu cá nhân của anh ấy là trở thành kiếm sĩ vĩ đại nhất trên toàn thế giới đã hoàn thành khi anh ấy giết cựu kiếm sĩ vĩ đại nhất trên toàn thế giới và là thủ lĩnh của gia tộc kẻ thù. Cả hai gia tộc đã thề sẽ chiến đấu cho đến khi mọi thành viên của gia tộc đối lập đều chết. Yang đã giết mọi thành viên, ngoại trừ một bé gái mà anh ta bắt gặp, tha thứ và quyết định trông chừng. Hành động này khiến Yang trở thành kẻ thù không đội trời chung của chính gia tộc anh ta, và buộc anh ta phải chạy trốn khỏi quê hương của mình.<br/>Sau khi lên đường đến miền Tây nước Mỹ , Yang đến Lode, một thị trấn nhỏ, bụi bặm, nơi thu hút chính từng là lễ hội hóa trang. Ở đó, anh ta tìm kiếm một người bạn chiến binh lừa đảo được người dân thị trấn gọi là Smiley. Yang phát hiện ra Smiley đã chết 3 năm trước, nhưng điều hành cửa hàng giặt là của thị trấn. Trong số những người dân thị trấn mà Yang gặp, anh được giới thiệu với một băng nhóm gồm những người thân thiện do Tám bóng lùn ( Tony Cox ), Ron ( Geoffrey Rush ), kẻ say rượu lang thang và Lynne ( Kate Bosworth ), một phụ nữ trẻ lanh lợi đã kết bạn với Mặt cười.'),
('Lich Hand To Destroy Flowers',N'Liêu Trai: Hoa Thần Giáng Phi',2,6,2020,80,'//ok.ru/videoembed/1868608899755',N'Vì báo ân cứu mạng,Nguyệt quý tiên tử Giáng Phi hạ phàm, nhất kiến chung tình với Tống Dật Trần chủnhân Xước Nhiên Trai, nhưng bất ngờ bị cuốn vàp một loạt phong ba vụ án Câytinh hút máu, con gái huyện lệnh cướp phu,… đồng thời đưa tới một trận đạichiến Yêu – Thần tại Tam Trùng Thiên.')
GO

--UPDATE tb_Phim
--SET UrlHinh = CONVERT(VARCHAR,(SELECT ID FROM tb_Phim P WHERE P.ID=tb_Phim.ID))+'.jpg'

UPDATE tb_Phim SET LuotXem=4344, LuotThich=4753 WHERE ID=10000
UPDATE tb_Phim SET LuotXem=1432, LuotThich=7331 WHERE ID=10001
UPDATE tb_Phim SET LuotXem=4455, LuotThich=7154 WHERE ID=10002
UPDATE tb_Phim SET LuotXem=5385, LuotThich=8546 WHERE ID=10003
UPDATE tb_Phim SET LuotXem=7080, LuotThich=6127 WHERE ID=10004
UPDATE tb_Phim SET LuotXem=3417, LuotThich=644 WHERE ID=10005
UPDATE tb_Phim SET LuotXem=5093, LuotThich=1172 WHERE ID=10006
UPDATE tb_Phim SET LuotXem=7597, LuotThich=1899 WHERE ID=10007
UPDATE tb_Phim SET LuotXem=3744, LuotThich=6226 WHERE ID=10008
UPDATE tb_Phim SET LuotXem=9812, LuotThich=5062 WHERE ID=10009
UPDATE tb_Phim SET LuotXem=8406, LuotThich=1341 WHERE ID=10010
UPDATE tb_Phim SET LuotXem=4687, LuotThich=1903 WHERE ID=10011
UPDATE tb_Phim SET LuotXem=4908, LuotThich=7767 WHERE ID=10012
UPDATE tb_Phim SET LuotXem=7221, LuotThich=7644 WHERE ID=10013
UPDATE tb_Phim SET LuotXem=6568, LuotThich=9499 WHERE ID=10014
UPDATE tb_Phim SET LuotXem=5875, LuotThich=4494 WHERE ID=10015
UPDATE tb_Phim SET LuotXem=9728, LuotThich=4253 WHERE ID=10016
UPDATE tb_Phim SET LuotXem=9664, LuotThich=9857 WHERE ID=10017
UPDATE tb_Phim SET LuotXem=52, LuotThich=2101 WHERE ID=10018
UPDATE tb_Phim SET LuotXem=3459, LuotThich=1409 WHERE ID=10019
UPDATE tb_Phim SET LuotXem=5175, LuotThich=543 WHERE ID=10020
UPDATE tb_Phim SET LuotXem=9123, LuotThich=8247 WHERE ID=10021
UPDATE tb_Phim SET LuotXem=5344, LuotThich=669 WHERE ID=10022
UPDATE tb_Phim SET LuotXem=1390, LuotThich=4528 WHERE ID=10023
UPDATE tb_Phim SET LuotXem=2648, LuotThich=232 WHERE ID=10024
UPDATE tb_Phim SET LuotXem=6458, LuotThich=9664 WHERE ID=10025
UPDATE tb_Phim SET LuotXem=1159, LuotThich=5966 WHERE ID=10026
UPDATE tb_Phim SET LuotXem=8142, LuotThich=6995 WHERE ID=10027
UPDATE tb_Phim SET LuotXem=4813, LuotThich=9274 WHERE ID=10028
UPDATE tb_Phim SET LuotXem=1159, LuotThich=1098 WHERE ID=10029
UPDATE tb_Phim SET LuotXem=7259, LuotThich=6541 WHERE ID=10030
UPDATE tb_Phim SET LuotXem=3590, LuotThich=2407 WHERE ID=10031
UPDATE tb_Phim SET LuotXem=8040, LuotThich=7751 WHERE ID=10032
UPDATE tb_Phim SET LuotXem=914, LuotThich=6659 WHERE ID=10033
UPDATE tb_Phim SET LuotXem=2460, LuotThich=4830 WHERE ID=10034
UPDATE tb_Phim SET LuotXem=2136, LuotThich=5838 WHERE ID=10035
UPDATE tb_Phim SET LuotXem=8274, LuotThich=4211 WHERE ID=10036
UPDATE tb_Phim SET LuotXem=4468, LuotThich=6734 WHERE ID=10037
UPDATE tb_Phim SET LuotXem=954, LuotThich=6455 WHERE ID=10038
UPDATE tb_Phim SET LuotXem=6798, LuotThich=3024 WHERE ID=10039
UPDATE tb_Phim SET LuotXem=691, LuotThich=9478 WHERE ID=10040
UPDATE tb_Phim SET LuotXem=3747, LuotThich=6877 WHERE ID=10041
UPDATE tb_Phim SET LuotXem=8520, LuotThich=902 WHERE ID=10042
UPDATE tb_Phim SET LuotXem=1491, LuotThich=6459 WHERE ID=10043
UPDATE tb_Phim SET LuotXem=6002, LuotThich=9361 WHERE ID=10044
UPDATE tb_Phim SET LuotXem=3735, LuotThich=6451 WHERE ID=10045
UPDATE tb_Phim SET LuotXem=2750, LuotThich=4234 WHERE ID=10046
UPDATE tb_Phim SET LuotXem=1235, LuotThich=9719 WHERE ID=10047
UPDATE tb_Phim SET LuotXem=8746, LuotThich=8162 WHERE ID=10048
UPDATE tb_Phim SET LuotXem=1065, LuotThich=9576 WHERE ID=10049
UPDATE tb_Phim SET LuotXem=3880, LuotThich=7006 WHERE ID=10050
UPDATE tb_Phim SET LuotXem=2503, LuotThich=3794 WHERE ID=10051
UPDATE tb_Phim SET LuotXem=5431, LuotThich=7411 WHERE ID=10052
UPDATE tb_Phim SET LuotXem=4807, LuotThich=3411 WHERE ID=10053
UPDATE tb_Phim SET LuotXem=5319, LuotThich=3042 WHERE ID=10054
UPDATE tb_Phim SET LuotXem=8450, LuotThich=1712 WHERE ID=10055
UPDATE tb_Phim SET LuotXem=2862, LuotThich=6728 WHERE ID=10056
UPDATE tb_Phim SET LuotXem=5439, LuotThich=1322 WHERE ID=10057
UPDATE tb_Phim SET LuotXem=5502, LuotThich=7241 WHERE ID=10058
UPDATE tb_Phim SET LuotXem=6233, LuotThich=251 WHERE ID=10059
UPDATE tb_Phim SET LuotXem=9530, LuotThich=6246 WHERE ID=10060
UPDATE tb_Phim SET LuotXem=460, LuotThich=960 WHERE ID=10061
UPDATE tb_Phim SET LuotXem=5142, LuotThich=3084 WHERE ID=10062
UPDATE tb_Phim SET LuotXem=6168, LuotThich=23 WHERE ID=10063
UPDATE tb_Phim SET LuotXem=5388, LuotThich=2478 WHERE ID=10064
UPDATE tb_Phim SET LuotXem=7635, LuotThich=9803 WHERE ID=10065
UPDATE tb_Phim SET LuotXem=6496, LuotThich=2983 WHERE ID=10066
UPDATE tb_Phim SET LuotXem=4932, LuotThich=7728 WHERE ID=10067
UPDATE tb_Phim SET LuotXem=7885, LuotThich=2080 WHERE ID=10068
UPDATE tb_Phim SET LuotXem=9343, LuotThich=3185 WHERE ID=10069
UPDATE tb_Phim SET LuotXem=3756, LuotThich=7168 WHERE ID=10070
UPDATE tb_Phim SET LuotXem=7549, LuotThich=6854 WHERE ID=10071
UPDATE tb_Phim SET LuotXem=4598, LuotThich=391 WHERE ID=10072
UPDATE tb_Phim SET LuotXem=4006, LuotThich=2370 WHERE ID=10073
UPDATE tb_Phim SET LuotXem=6135, LuotThich=9243 WHERE ID=10074
UPDATE tb_Phim SET LuotXem=5383, LuotThich=5622 WHERE ID=10075
UPDATE tb_Phim SET LuotXem=5319, LuotThich=4181 WHERE ID=10076
UPDATE tb_Phim SET LuotXem=3077, LuotThich=2689 WHERE ID=10077
UPDATE tb_Phim SET LuotXem=7794, LuotThich=9108 WHERE ID=10078
UPDATE tb_Phim SET LuotXem=9863, LuotThich=3461 WHERE ID=10079
UPDATE tb_Phim SET LuotXem=8952, LuotThich=525 WHERE ID=10080
UPDATE tb_Phim SET LuotXem=4555, LuotThich=4303 WHERE ID=10081
UPDATE tb_Phim SET LuotXem=1164, LuotThich=6378 WHERE ID=10082
UPDATE tb_Phim SET LuotXem=4164, LuotThich=9806 WHERE ID=10083
UPDATE tb_Phim SET LuotXem=3055, LuotThich=6198 WHERE ID=10084
UPDATE tb_Phim SET LuotXem=6522, LuotThich=601 WHERE ID=10085
UPDATE tb_Phim SET LuotXem=2808, LuotThich=9991 WHERE ID=10086
UPDATE tb_Phim SET LuotXem=7580, LuotThich=1498 WHERE ID=10087
UPDATE tb_Phim SET LuotXem=6403, LuotThich=4526 WHERE ID=10088
UPDATE tb_Phim SET LuotXem=6655, LuotThich=1807 WHERE ID=10089
UPDATE tb_Phim SET LuotXem=3393, LuotThich=2151 WHERE ID=10090
UPDATE tb_Phim SET LuotXem=9809, LuotThich=7589 WHERE ID=10091
UPDATE tb_Phim SET LuotXem=7408, LuotThich=9092 WHERE ID=10092
UPDATE tb_Phim SET LuotXem=6210, LuotThich=3802 WHERE ID=10093
UPDATE tb_Phim SET LuotXem=5887, LuotThich=7281 WHERE ID=10094
UPDATE tb_Phim SET LuotXem=4871, LuotThich=2831 WHERE ID=10095
UPDATE tb_Phim SET LuotXem=3741, LuotThich=6225 WHERE ID=10096
UPDATE tb_Phim SET LuotXem=9441, LuotThich=4728 WHERE ID=10097
UPDATE tb_Phim SET LuotXem=8586, LuotThich=9143 WHERE ID=10098
UPDATE tb_Phim SET LuotXem=6901, LuotThich=3643 WHERE ID=10099
UPDATE tb_Phim SET LuotXem=1031, LuotThich=668 WHERE ID=10100

INSERT INTO tb_Phim_TheLoai(idPhim, idTheLoai)
VALUES
(10000,3),(10000,8),(10000,11),
(10001,3),
(10002,2),(10002,13),
(10003,12),
(10004,3),(10004,5),(10004,15),
(10005,5),(10005,15),
(10006,12),
(10007,6),
(10008,4),(10008,10),(10008,15),
(10009,4),(10009,12),
(10010,8),
(10011,6),(10011,7),
(10012,3),
(10013,3),
(10014,5),(10014,15),
(10015,7),(10015,16),
(10016,16),
(10017,3),(10017,9),
(10018,4),(10018,10),(10018,15),
(10019,3),
(10020,6),(10020,7),(10020,4),
(10021,12),
(10022,8),(10022,17),
(10023,8),
(10024,3),
(10025,6),(10025,7),(10025,14),
(10026,12),
(10027,12),
(10028,18),
(10029,6),(10029,7),
(10030,3),
(10031,10),(10031,15),
(10032,4),(10032,10),
(10033,10),(10033,14),(10033,15),
(10034,8),
(10035,12),
(10036,8),
(10037,14),
(10038,12),
(10039,3),(10039,11),(10039,12),
(10040,6),(10040,7),(10040,10),(10040,15),
(10041,3),(10041,9),
(10042,12),
(10043,3),(10043,15),
(10044,8),
(10045,3),
(10046,3),(10046,12),
(10047,5),(10047,15),
(10048,3),(10048,4),
(10049,12),
(10050,12),
(10051,9),
(10052,8),
(10053,3),(10053,5),
(10054,8),
(10055,7),
(10056,12),
(10057,12),
(10058,3),
(10059,3),(10060,19),
(10060,7),(10060,16),
(10061,3),
(10062,3),
(10063,8),(10063,16),
(10064,14),
(10065,3),
(10066,3),(10066,9),
(10067,10),(10067,15),
(10068,3),(10068,4),
(10069,12),
(10070,8),
(10071,3),
(10072,3),
(10073,3),
(10074,12),(10074,15),
(10075,4),(10075,8),
(10076,4),(10076,11),
(10077,11),(10077,12),
(10078,3),(10078,4),(10078,7),
(10079,8),
(10080,15),
(10081,8),
(10082,12),
(10083,4),(10083,12),
(10084,8),
(10085,7),(10085,6),(10085,11),
(10086,6),(10086,10),
(10087,12),
(10088,12),(10088,15),
(10089,12),
(10090,8),
(10091,15),
(10092,4),
(10093,4),(10093,10),(10093,12),
(10094,3),(10094,6),(10094,7),(10094,16),
(10095,8),
(10096,8),
(10097,8),
(10098,3),(10098,9),
(10099,3),(10099,6),
(10100,6),(10100,7),(10100,15),(10100,16)
GO

INSERT INTO tb_Phim_DaoDien(idPhim, idDaoDien)
VALUES
(10000,2),
(10001,3),
(10002,4),
(10003,5),
(10004,6),
(10005,7),
(10006,8),
(10007,9),
(10008,10),
(10009,11),
(10010,12),
(10011,13),
(10012,14),
(10013,15),
(10014,16),
(10015,17),
(10016,18),
(10017,19),
(10018,20),
(10019,21),
(10020,22),
(10021,23),
(10022,24),
(10023,25),
(10024,26),
(10025,27),
(10026,28),
(10027,29),
(10028,30),
(10029,31),
(10030,32),
(10031,1),
(10032,33),
(10033,34),
(10034,35),
(10035,36),
(10036,37),
(10037,38),
(10038,39),
(10039,40),
(10040,1),
(10041,41),
(10042,42),
(10043,43),
(10044,44),
(10045,45),
(10046,46),
(10047,47),
(10048,48),
(10049,49),
(10050,50),
(10051,51),
(10052,52),
(10053,53),
(10054,54),
(10055,55),
(10056,56),
(10057,57),
(10058,58),
(10059,59),
(10060,60),
(10061,61),
(10062,62),
(10063,34),
(10064,63),
(10065,64),
(10066,65),
(10067,66),
(10068,67),
(10069,68),
(10070,1),
(10071,69),
(10072,70),
(10073,71),
(10074,72),
(10075,73),
(10076,74),
(10077,75),
(10078,76),
(10079,77),
(10080,78),
(10081,79),
(10082,80),
(10083,81),
(10084,82),
(10085,83),
(10086,84),
(10087,85),
(10088,86),
(10089,87),
(10090,88),
(10091,89),
(10092,90),
(10093,91),
(10094,1),
(10095,92),
(10096,93),
(10097,94),
(10098,95),
(10099,96),
(10100,1)
GO

INSERT INTO tb_Phim_DienVien(idPhim, idDienVien)
VALUES
(10000,2),(10000,3),(10000,4),(10000,5),
(10001,6),(10001,7),(10001,8),
(10002,9),(10002,10),(10002,11),(10002,12),
(10003,13),(10003,14),(10003,15),
(10004,16),(10004,17),(10004,18),
(10005,19),(10005,20),(10005,21),
(10006,22),(10006,23),(10006,24),
(10007,25),(10007,26),(10007,27),
(10008,28),(10008,29),(10008,30),(10008,31),(10008,32),
(10009,33),(10009,34),(10009,35),(10009,36),
(10010,37),(10010,38),(10010,39),
(10011,40),(10011,41),(10011,42),
(10012,43),(10012,44),(10012,45),
(10013,46),(10013,47),(10013,48),
(10014,49),(10014,50),(10014,51),
(10015,52),(10015,53),(10015,54),
(10016,55),(10016,56),(10016,57),
(10017,58),(10017,59),(10017,60),
(10018,61),(10018,62),(10018,63),
(10019,64),(10019,65),(10019,66),
(10020,67),(10020,68),(10020,69),
(10021,70),(10021,71),(10021,72),
(10022,73),(10022,74),(10022,75),
(10023,76),(10023,77),(10023,78),
(10024,79),(10024,80),(10024,81),
(10025,82),(10025,83),(10025,84),(10025,85),
(10026,86),(10026,87),(10026,88),
(10027,89),(10027,90),(10027,91),
(10028,92),(10028,93),(10028,94),
(10029,95),(10029,96),(10029,97),(10029,98),
(10030,99),(10030,100),
(10031,101),(10031,102),(10031,103),
(10032,104),(10032,105),(10032,106),
(10033,107),(10033,108),(10033,109),(10033,8),
(10034,110),(10034,111),(10034,112),
(10035,113),(10035,114),(10035,115),
(10036,116),(10036,117),(10036,118),
(10037,119),(10037,120),(10037,121),
(10038,122),(10038,123),(10038,124),
(10039,125),(10039,126),(10039,127),
(10040,128),(10040,129),(10040,130),
(10041,25),(10041,131),(10041,132),
(10042,133),(10042,134),(10042,135),
(10043,136),(10043,137),(10043,138),
(10044,139),(10044,140),(10044,141),
(10045,142),(10045,143),(10045,144),
(10046,145),(10046,146),(10046,147),
(10047,148),(10047,149),(10047,150),
(10048,151),(10048,152),(10048,153),
(10049,154),(10049,155),(10049,156),
(10050,157),(10050,158),(10050,159),
(10051,160),(10051,161),(10051,162),
(10052,163),(10052,164),(10052,165),
(10053,166),(10053,167),(10053,168),
(10054,169),(10054,170),(10054,171),(10054,172),(10054,173),
(10055,174),
(10056,175),(10056,176),(10056,177),
(10057,178),(10057,179),(10057,180),(10057,181),
(10058,182),(10058,183),(10058,184),
(10059,185),(10059,186),(10059,187),
(10060,188),(10060,189),(10060,190),
(10061,191),(10061,192),(10061,85),
(10062,193),(10062,194),(10062,195),
(10063,196),(10063,197),
(10064,198),(10064,199),(10064,200),
(10065,201),(10065,202),(10065,118),
(10066,203),(10066,204),(10066,205),
(10067,206),(10067,207),
(10068,208),(10068,209),(10068,210),(10068,211),(10068,212),
(10069,213),
(10070,214),(10070,215),(10070,216),
(10071,217),(10071,218),(10071,219),
(10072,220),(10072,221),(10072,222),
(10073,223),(10073,224),(10073,225),
(10074,226),(10074,227),(10074,228),
(10075,229),(10075,230),(10075,231),
(10076,232),(10076,233),(10076,234),
(10077,235),(10077,236),(10077,237),
(10078,238),(10078,239),(10078,240),
(10079,241),(10079,242),(10079,243),
(10080,244),(10080,245),(10080,246),
(10081,1),
(10082,247),(10082,248),
(10083,249),(10083,250),(10083,251),
(10084,252),(10084,253),(10084,254),
(10085,255),(10085,256),(10085,257),
(10086,258),(10086,259),(10086,260),
(10087,261),(10087,262),(10087,263),
(10088,264),(10088,265),(10088,266),
(10089,267),(10089,268),(10089,269),(10089,270),
(10090,271),(10090,272),(10090,273),
(10091,274),(10091,275),(10091,276),
(10092,277),(10092,278),(10092,279),
(10093,280),(10093,281),(10093,282),
(10094,283),(10094,284),(10094,285),
(10095,286),(10095,287),(10095,288),(10095,289),(10095,290),
(10096,291),(10096,292),(10096,293),(10096,294),
(10097,295),(10097,296),(10097,297),
(10098,298),(10098,299),(10098,300),
(10099,301),(10091,302),(10091,303),
(10100,304),(10100,305)
GO


-------------------------------------------------
--TRIGGER
-------------------------------------------------
CREATE TRIGGER trg_LatestUpdate ON tb_Phim
AFTER UPDATE
AS
	UPDATE tb_Phim
	SET TgianCapNhat=GETDATE()
	WHERE ID = (SELECT ID FROM inserted)
GO

CREATE TRIGGER trg_LikeMovie ON tb_DaThich
FOR INSERT
AS
	UPDATE tb_Phim
	SET LuotThich=LuotThich+1
	WHERE ID=(SELECT idPhim FROM inserted)
GO

CREATE TRIGGER trg_LikeMovieDel ON tb_DaThich
FOR DELETE
AS
	UPDATE tb_Phim
	SET LuotThich=LuotThich-1
	WHERE ID=(SELECT idPhim FROM deleted)
GO

-------------------------------------------------
--CURSOR
-------------------------------------------------

DECLARE cur_UpdateLinkHinh CURSOR
DYNAMIC
FOR SELECT ID, UrlHinh FROM tb_Phim
OPEN cur_UpdateLinkHinh
DECLARE @ID INT, @URL VARCHAR(1000)
FETCH NEXT FROM cur_UpdateLinkHinh INTO @ID, @URL
WHILE(@@FETCH_STATUS=0)
BEGIN
	UPDATE tb_Phim
	SET UrlHinh = CONVERT(VARCHAR, @ID)+'.jpg' WHERE ID=@ID
	FETCH NEXT FROM cur_UpdateLinkHinh INTO @ID, @URL
END
CLOSE cur_UpdateLinkHinh
DEALLOCATE cur_UpdateLinkHinh
GO

-------------------------------------------------
--QUERY, PROCEDURE, FUNCTION
-------------------------------------------------
--Lấy danh sách phim
CREATE PROC up_MovieList
AS
	SELECT P.ID, P.TenPhim_en, P.TenPhim_vi, NamPhatHanh, DanhMuc, QuocGia, LuotXem, LuotThich, UrlHinh
	FROM tb_Phim P
	WHERE DaXoa=0 
	ORDER BY TgianCapNhat DESC
GO

--Lấy danh sách phim (chi tiết)
CREATE PROC up_MovieListDetail 
AS
	SELECT P.ID, TenPhim_en, TenPhim_vi, D.DanhMuc, Q.QuocGia, NamPhatHanh, ThoiLuong, UrlPhim, UrlHinh, MoTa, TgianCapNhat
	FROM tb_Phim P, tb_QuocGia Q, tb_DanhMuc D
	WHERE P.QuocGia=Q.ID AND P.DanhMuc=D.ID
	AND P.DaXoa=0
	ORDER BY TgianCapNhat DESC
GO

--Lấy danh sách phim (chi tiết) viết theo function
CREATE FUNCTION uf_MovieListDetail()
RETURNS TABLE
AS
	RETURN (
	SELECT P.ID, TenPhim_en, TenPhim_vi, D.DanhMuc, Q.QuocGia, NamPhatHanh, ThoiLuong, UrlPhim, UrlHinh, MoTa, TgianCapNhat
	FROM tb_Phim P, tb_QuocGia Q, tb_DanhMuc D
	WHERE P.QuocGia=Q.ID AND P.DanhMuc=D.ID
	AND P.DaXoa=0)
GO

--Lọc phim theo Danh mục
CREATE PROC up_MovieListByCatalogue @idDanhMuc INT
AS
	SELECT P.ID, P.TenPhim_en, P.TenPhim_vi, NamPhatHanh, DanhMuc, QuocGia, LuotXem, LuotThich, UrlHinh
	FROM tb_Phim P
	WHERE DanhMuc=@idDanhMuc
	AND DaXoa=0 
	ORDER BY TgianCapNhat DESC
GO

--Lọc phim theo Danh mục viết theo function
CREATE FUNCTION uf_MovieListByCatalogue(@idDanhMuc INT)
RETURNS @MovieList TABLE(
	ID INT,
    TenPhim_en VARCHAR(120),
    TenPhim_vi NVARCHAR(120),
	NamPhatHanh INT,
	DanhMuc INT,
    QuocGia INT,
	LuotXem INT,
	LuotThich INT,
	UrlHinh VARCHAR(1000))
AS
BEGIN
	INSERT INTO @MovieList 
	SELECT P.ID, P.TenPhim_en, P.TenPhim_vi, NamPhatHanh, DanhMuc, QuocGia, LuotXem, LuotThich, UrlHinh
	FROM tb_Phim P
	WHERE DanhMuc=@idDanhMuc
	AND DaXoa=0
	RETURN
END
GO

--Lọc phim theo Thể loại
CREATE PROC up_MovieListByCategory @idTheLoai INT
AS
	SELECT P.ID, P.TenPhim_en, P.TenPhim_vi, NamPhatHanh, DanhMuc, QuocGia, LuotXem, LuotThich, UrlHinh
	FROM tb_Phim P, tb_Phim_TheLoai PL
	WHERE P.ID=PL.idPhim
	AND PL.idTheLoai=@idTheLoai
	AND P.DaXoa=0
GO

--Lọc phim theo Thể loai viết theo function
CREATE FUNCTION uf_MovieListByCategory(@idTheLoai INT)
RETURNS @MovieList TABLE(
	ID INT,
    TenPhim_en VARCHAR(120),
    TenPhim_vi NVARCHAR(120),
	NamPhatHanh INT,
	DanhMuc INT,
    QuocGia INT,
	LuotXem INT,
	LuotThich INT,
	UrlHinh VARCHAR(1000))
AS
BEGIN
	INSERT INTO @MovieList 
	SELECT P.ID, P.TenPhim_en, P.TenPhim_vi, NamPhatHanh, DanhMuc, QuocGia, LuotXem, LuotThich, UrlHinh
	FROM tb_Phim P, tb_Phim_TheLoai PL
	WHERE P.ID=PL.idPhim
	AND PL.idTheLoai=@idTheLoai
	AND P.DaXoa=0
	RETURN
END
GO

--Lọc top 10 phim nổi bật (gần nhất, nhiều lượt xem nhất)
CREATE PROC up_MovieListTop10ByCategory @idTheLoai INT
AS
	SELECT TOP 10 P.ID, P.TenPhim_en, P.TenPhim_vi, NamPhatHanh, DanhMuc, QuocGia, LuotXem, LuotThich, UrlHinh
	FROM tb_Phim P, tb_Phim_TheLoai PL
	WHERE P.ID=PL.idPhim
	AND PL.idTheLoai=@idTheLoai
	AND P.DaXoa=0
	ORDER BY LuotThich DESC, LuotXem DESC, TgianCapNhat DESC 
GO

--Lọc phim theo Quốc gia
CREATE PROC up_MovieListByNation @idQuocGia INT
AS
	SELECT P.ID, TenPhim_en, TenPhim_vi, NamPhatHanh, ThoiLuong, UrlPhim, UrlHinh, MoTa, TgianCapNhat, LuotXem, LuotThich, Q.QuocGia, ThuTu
	FROM tb_Phim P, tb_QuocGia Q
	WHERE P.QuocGia=Q.ID AND Q.ID=@idQuocGia
	AND P.DaXoa=0
GO

--Lọc phim theo Quốc gia viết theo function
CREATE FUNCTION uf_MovieListByNation(@idQuocGia INT)
RETURNS TABLE
AS
	RETURN (SELECT P.ID, TenPhim_en, TenPhim_vi, NamPhatHanh, ThoiLuong, UrlPhim, UrlHinh, MoTa, TgianCapNhat, LuotXem, LuotThich, Q.QuocGia, ThuTu
	FROM tb_Phim P, tb_QuocGia Q
	WHERE P.QuocGia=Q.ID AND Q.ID=@idQuocGia
	AND P.DaXoa=0)
GO

--Lấy thông tin phim chi tiết
CREATE PROC up_MovieDetailById @idPhim INT
AS
	SELECT P.ID, TenPhim_en, TenPhim_vi, NamPhatHanh, ThoiLuong, UrlPhim, UrlHinh, MoTa, TgianCapNhat, LuotXem, LuotThich, Q.QuocGia
	FROM tb_Phim P, tb_QuocGia Q
	WHERE  P.QuocGia=Q.ID AND P.ID=@idPhim
	AND P.DaXoa=0
GO

--Lấy danh sách diễn viên của 1 phim
CREATE PROC up_ActorsByMovie @idPhim INT
AS
	SELECT ID, TenDienVien FROM tb_DienVien, tb_Phim_DienVien
	WHERE tb_DienVien.ID=tb_Phim_DienVien.idDienVien AND idPhim=@idPhim 
GO

--Lấy danh sách thể loại của 1 phim
CREATE PROC up_CategoriesByMovie @idPhim INT
AS
	SELECT ID, TheLoai FROM tb_TheLoai, tb_Phim_TheLoai
	WHERE tb_TheLoai.ID=tb_Phim_TheLoai.idTheLoai AND idPhim=@idPhim
GO

--Lấy danh sách đạo diễn của 1 phim
CREATE PROC up_DirectorsByMovie @idPhim INT
AS
	SELECT ID, TenDaoDien FROM tb_DaoDien, tb_Phim_DaoDien
	WHERE tb_DaoDien.ID=tb_Phim_DaoDien.idDaoDien AND idPhim=@idPhim
GO

--Thêm mới phim
CREATE PROC up_InsertMovie
(
@TenPhim_en VARCHAR(120),
@TenPhim_vi NVARCHAR(120),
@DanhMuc INT,
@QuocGia INT,
@NamPhatHanh INT,
@ThoiLuong INT,
@UrlPhim VARCHAR(1000),
@UrlHinh VARCHAR(1000),
@MoTa NVARCHAR(MAX),
@IdOutput INT OUTPUT
)
AS
BEGIN
	INSERT INTO tb_Phim(TenPhim_en, TenPhim_vi, DanhMuc, QuocGia, NamPhatHanh, ThoiLuong, UrlPhim, UrlHinh, MoTa)
	VALUES (@TenPhim_en,@TenPhim_vi,@DanhMuc,@QuocGia,@NamPhatHanh,@ThoiLuong,@UrlPhim,@UrlHinh,@MoTa)
	SELECT @IdOutput = SCOPE_IDENTITY()
END
GO

--Cập nhật phim
CREATE PROC up_UpdateMovie
(
@ID INT,
@TenPhim_en VARCHAR(120),
@TenPhim_vi NVARCHAR(120),
@DanhMuc INT,
@QuocGia INT,
@NamPhatHanh INT,
@ThoiLuong INT,
@UrlPhim VARCHAR(1000),
@UrlHinh VARCHAR(1000),
@MoTa NVARCHAR(MAX)
)
AS
BEGIN
	UPDATE tb_Phim
	SET TenPhim_en=@TenPhim_en, TenPhim_vi=@TenPhim_vi, DanhMuc=@DanhMuc, QuocGia=@QuocGia, NamPhatHanh=@NamPhatHanh, ThoiLuong=@ThoiLuong, UrlPhim=@UrlPhim, UrlHinh=@UrlHinh, MoTa=@MoTa
	WHERE ID=@ID
END
GO

----Xoá tất cả thể loại của 1 phim
CREATE PROC up_DeleteCategoriesByMovie @idPhim INT
AS
	DELETE tb_Phim_TheLoai
	WHERE idPhim=@idPhim
GO
----Xoá tất cả diễn viên của 1 phim
CREATE PROC up_DeleteActorsByMovie @idPhim INT
AS
	DELETE tb_Phim_DienVien
	WHERE idPhim=@idPhim
GO
----Xoá tất cả đạo diễn của 1 phim
CREATE PROC up_DeleteDirectorsByMovie @idPhim INT
AS
	DELETE tb_Phim_DaoDien
	WHERE idPhim=@idPhim
GO

--Xoá phim
CREATE PROC up_DeleteMovie @ID INT
AS
	UPDATE tb_Phim SET DaXoa=1
	WHERE ID=@ID
GO

---------------------------------------
--Kiểm tra tài khoản tồn tại
CREATE FUNCTION uf_CheckUsername (@Username VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*) FROM tb_TaiKhoan WHERE Username=@Username)
END
GO

--Đăng ký tài khoản
CREATE PROC up_Register 
@Username VARCHAR(30), 
@Password VARCHAR(1000), 
@HoTen NVARCHAR(120), 
@Email VARCHAR(120),
@SDT VARCHAR(10),
@LoaiTK BIT
AS
	IF(SELECT dbo.uf_CheckUsername(@Username))=0
		BEGIN
			INSERT INTO tb_TaiKhoan (Username, Password, HoTen, Email, SDT, LoaiTK)
			VALUES(@Username, @Password, @HoTen, @Email, @SDT, @LoaiTK)
		END
	ELSE RETURN -1
GO

--Đăng nhập
CREATE PROC up_Login @Username VARCHAR(30), @Password VARCHAR(1000)
AS
	SELECT * FROM tb_TaiKhoan WHERE Username=@Username AND Password=@Password
GO

--Cập nhật tài khoản
CREATE PROC up_UpdateAccount
@Username VARCHAR(30), 
@Password VARCHAR(1000), 
@HoTen NVARCHAR(120), 
@Email VARCHAR(120),
@SDT VARCHAR(10),
@LoaiTK BIT
AS
	UPDATE tb_TaiKhoan
	SET Password=@Password, HoTen=@HoTen, Email=@Email, SDT=@SDT, LoaiTK=@LoaiTK
	WHERE Username=@Username
GO

--Cập nhật thông tin tài khoản (User)
CREATE PROC up_UpdateInforByUser
@Username VARCHAR(30), 
@HoTen NVARCHAR(120), 
@Email VARCHAR(120),
@SDT VARCHAR(10)
AS
	UPDATE tb_TaiKhoan
	SET HoTen=@HoTen, Email=@Email, SDT=@SDT
	WHERE Username=@Username
GO

--Xoá danh mục (Nếu tồn tại phim thuộc danh mục cần xoá, thì chuyển danh mục của phim đó thành 'Đang cập nhật')
CREATE PROC up_DeleteCatalogue @ID INT
AS
	IF(SELECT COUNT(*) FROM tb_Phim WHERE DanhMuc=@ID)>0
		BEGIN
			DECLARE @IDTMP INT
			IF(SELECT COUNT(*) FROM tb_DanhMuc WHERE DanhMuc=N'Đang cập nhật')=0
				BEGIN
					INSERT INTO tb_DanhMuc
					VALUES (N'Đang cập nhật',NULL)
				END
			SET @IDTMP=(SELECT ID FROM tb_DanhMuc WHERE DanhMuc=N'Đang cập nhật')

			ALTER TABLE tb_Phim DISABLE TRIGGER trg_LatestUpdate
			UPDATE tb_Phim
			SET DanhMuc=@IDTMP, TgianCapNhat=GETDATE() WHERE tb_Phim.DanhMuc=@ID
			ALTER TABLE tb_Phim ENABLE TRIGGER trg_LatestUpdate
		END

	DELETE FROM tb_DanhMuc
	WHERE ID=@ID
GO

--Xoá quốc gia (Nếu tồn tại phim thuộc quốc gia cần xoá, thì chuyển quốc gia của phim đó thành 'Đang cập nhật')
CREATE PROC up_DeleteNation @ID INT
AS
	IF(SELECT COUNT(*) FROM tb_Phim WHERE QuocGia=@ID)>0
		BEGIN
			DECLARE @IDTMP INT
			IF(SELECT COUNT(*) FROM tb_QuocGia WHERE QuocGia=N'Đang cập nhật')=0
				BEGIN
					INSERT INTO tb_QuocGia
					VALUES (N'Đang cập nhật',NULL)
				END
			SET @IDTMP=(SELECT ID FROM tb_QuocGia WHERE QuocGia=N'Đang cập nhật')
			
			ALTER TABLE tb_Phim DISABLE TRIGGER trg_LatestUpdate
			UPDATE tb_Phim
			SET QuocGia=@IDTMP, TgianCapNhat=GETDATE() WHERE tb_Phim.QuocGia=@ID
			ALTER TABLE tb_Phim ENABLE TRIGGER trg_LatestUpdate
		END

	DELETE FROM tb_QuocGia
	WHERE ID=@ID
GO

--Xóa thể loại
CREATE PROC up_DeleteCategories @ID INT
AS
	DELETE FROM tb_Phim_TheLoai WHERE idTheLoai=@ID
	DELETE FROM tb_TheLoai WHERE ID=@ID
GO

--Xóa đạo diễn
CREATE PROC up_DeleteDirectors @ID INT
AS
	DELETE FROM tb_Phim_DaoDien WHERE idDaoDien=@ID
	DELETE FROM tb_DaoDien WHERE ID=@ID
GO

--Xóa diễn viên
CREATE PROC up_DeleteActors @ID INT
AS
	DELETE FROM tb_Phim_DienVien WHERE idDienVien=@ID
	DELETE FROM tb_DienVien WHERE ID=@ID
GO

--Thích phim
CREATE PROC up_LikeMovie @Username VARCHAR(30), @idPhim INT
AS
	IF(SELECT COUNT(*) FROM tb_DaThich WHERE Username=@Username AND idPhim=@idPhim)>0
		DELETE tb_DaThich WHERE Username=@Username AND idPhim=@idPhim
	ELSE
		INSERT INTO tb_DaThich VALUES(@Username,@idPhim)
GO

--Lấy danh sách phim người dùng đã thích
CREATE FUNCTION uf_GetMovieLiked (@Username VARCHAR(30))
RETURNS TABLE
AS
	RETURN (SELECT ID, TenPhim_en, TenPhim_vi, NamPhatHanh, DanhMuc, QuocGia, LuotXem, LuotThich, UrlHinh
			FROM tb_Phim WHERE ID IN (SELECT idPhim FROM tb_DaThich WHERE Username=@Username))
GO

-------------------------------------------------
--BACKUP, RESTORE
-------------------------------------------------
--Full backup
BACKUP DATABASE dbWebFilm TO DISK = 'C:\dbWebFilm.bak'

--Differential backup
BACKUP DATABASE dbWebFilm TO DISK = 'C:\dbWebFilm_diff.bak' 
WITH DIFFERENTIAL

--Transaction log backup
BACKUP LOG dbWebFilm TO DISK = 'C:\dbWebFilm_log.trn'

--Restore full backup gần nhất
RESTORE DATABASE dbWebFilm FROM DISK ='C:\dbWebFilm.bak'
WITH NORECOVERY
GO
--Restore differential backup gần với thời gian sự cố nhất
RESTORE DATABASE dbWebFilm FROM DISK ='C:\dbWebFilm_diff.bak'
WITH NORECOVERY
GO
--Restore transaction log backup gần với thời gian sự cố nhất
RESTORE DATABASE dbWebFilm FROM DISK ='C:\dbWebFilm_log.trn'
WITH RECOVERY
GO

-------------------------------------------------
--Phân quyền người dùng
-------------------------------------------------
--Tạo tài khoản đăng nhập
sp_addlogin 'admin', 'admin123' --Quản trị viên toàn hệ thống
GO
sp_addlogin 'creator', 'creator123' --Quản trị viên nội dung
GO
sp_addlogin 'user', 'user123' --Người dùng
GO

--Tạo tài khoản người dùng
sp_adduser 'admin', 'admin'
GO
sp_adduser 'creator', 'creator'
GO
sp_adduser 'user', 'user'
GO

--Tạo nhóm quyền
sp_addrole 'group_creator'
GO
sp_addrole 'group_user'
GO

--Thêm người dùng vào nhóm quyền
sp_addsrvrolemember N'admin', N'sysadmin' --Thêm admin vào nhóm quyền server role (sysadmin) để có toàn quyền
GO
sp_addrolemember 'group_creator', 'creator'
GO
sp_addrolemember 'group_user', 'user'
GO

--Cấp quyền
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_DanhMuc TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_DaoDien TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_DaThich TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_DienVien TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_Phim TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_Phim_DaoDien TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_Phim_DienVien TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_Phim_TheLoai TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_QuocGia TO group_creator
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_TheLoai TO group_creator

GRANT SELECT ON tb_DanhMuc TO group_user
GRANT SELECT ON tb_DaoDien TO group_user
GRANT SELECT ON tb_DaThich TO group_user
GRANT SELECT ON tb_DienVien TO group_user
GRANT SELECT ON tb_Phim TO group_user
GRANT SELECT ON tb_Phim_DaoDien TO group_user
GRANT SELECT ON tb_Phim_DienVien TO group_user
GRANT SELECT ON tb_Phim_TheLoai TO group_user
GRANT SELECT ON tb_QuocGia TO group_user
GRANT SELECT ON tb_TheLoai TO group_user