program BioskopITB;

uses sysutils,uTampilMenu,uType;

var
	T : TabFilm;
	i, j, k : integer;
	S : TTanggal;
	M : TabDataMember;
	pilihan : string;
	x : char;

PROCEDURE F1load (var T: TabFilm; var S: TTanggal; var M: TabDataMember);

	{ I.S. T belum berisi }
	{ F.S. T terisi dari file eksternal }

	var
		F : text;
		ss : ansistring;
		psg, len : integer;
		Jaam : Array[1..10] of Array[1..4] of string;

	begin
		Assign(F,'DataFilm.txt'); // Load Data Film
		Reset(F);
			i := 1; // film ke i
			while (not(EOF(F))) do
			begin
				readln(F,ss);
				for j := 1 to 6 do // Harga weekend tidak diikutkan karena tidak ada guard setelah nya
				begin
					psg:=pos(' | ',ss)-1; // -1 karena spasi sebelum guard tidak dihitung
					case j of
						1 : T.TDF[i].Judul := copy(ss,1,psg);
						2 : T.TDF[i].Genre := copy(ss,1,psg);
						3 : T.TDF[i].Rating := copy(ss,1,psg);
						4 : T.TDF[i].Durasi := copy(ss,1,psg);
						5 : T.TDF[i].Sinopsis := copy(ss,1,psg);
						6 : val(copy(ss,1,psg),T.TDF[i].Harga.WD);
					end;
					len := length(copy(ss,1,psg))+3; // +3 karena ' | ' termasuk
					delete(ss,1,len);
				end;
				val(copy(ss,1,5),T.TDF[i].Harga.WE);
				i := i + 1;
			end;
			T.FNeff := i - 1; // -1 karena inisasi awal = 1
		close(F);

		Assign(F,'JadwalFilm.txt'); // Load Jadwal FIlm 
		Reset(F);
			i := 1; // film ke i
			j := 0; // jam ke j
			while (not(EOF(F))) do
			begin
				readln(F,ss);
				psg := pos(' | ',ss)-1;
				if (T.TDF[i].Judul = copy(ss,1,psg)) then
				begin
					len := length(copy(ss,1,psg))+3;
					delete(ss,1,len);
					
					psg := pos(' | ',ss)-1;
					j := j + 1;
					Jaam[i][j] := copy(ss,1,psg); // simpan dulu ke var Jaam lalu dipindah ke var T.TDF[i].Tayang.Tanggal[j].TJ[k].Jam
					if (j=4) then j := 0;

					len := length(copy(ss,1,psg))+3;
					delete(ss,1,len);

					for k := 1 to 3 do
					begin
						psg := pos(' | ',ss)-1;
						len := length(copy(ss,1,psg))+3;
						case k of
							1 : val(copy(ss,1,psg),T.TDF[i].Tayang.ATanggal);
							2 : val(copy(ss,1,psg),T.TDF[i].Tayang.Bulan);
							3 : val(copy(ss,1,psg),T.TDF[i].Tayang.Tahun);
						end;
						delete(ss,1,len);
					end;
					val(copy(ss,1,1),T.TDF[i].Tayang.Hari);
				end else 
				begin
					i := i + 1;
					psg := pos(' | ',ss)-1;
					len := length(copy(ss,1,psg))+3;
					delete(ss,1,len);
					
					psg := pos(' | ',ss)-1;
					j := j + 1;
					Jaam[i][j] := copy(ss,1,psg); // simpan dulu ke var Jaam lalu dipindah ke var T.TDF[i].Tayang.Tanggal[j].TJ[k].Jam
					if (j=4) then j := 0;

					len := length(copy(ss,1,psg))+3;
					delete(ss,1,len);

					for k := 1 to 3 do
					begin
						psg := pos(' | ',ss)-1;
						len := length(copy(ss,1,psg))+3;
						case k of
							1 : val(copy(ss,1,psg),T.TDF[i].Tayang.ATanggal);
							2 : val(copy(ss,1,psg),T.TDF[i].Tayang.Bulan);
							3 : val(copy(ss,1,psg),T.TDF[i].Tayang.Tahun);
						end;
						delete(ss,1,len);
					end;
					val(copy(ss,1,1),T.TDF[i].Tayang.Hari);
				end;
			end;
		close(F);

		// Pemindahan nilai di Jaam ke Variabel T.TDF[i].Tayang.Tanggal[j].TJ[k].Jam
		for i := 1 to T.FNeff do
		begin
			for j := 1 to T.TDF[i].Tayang.Hari do
			begin
				for k := 1 to 4 do
				begin
					T.TDF[i].Tayang.Tanggal[j].TJ[k].Jam := Jaam[i][k];
				end;
			end;
		end;


		Assign(F,'DataKapasitas.txt'); //Asumsi isi dari "DataKapasitas.txt" sesuai dengan jadwal film
		Reset(F);
			i := 1; // film ke i
			j := 1; // tanggal ke j
			k := 1; // jam ke k

			while (not(EOF(F))) do
			begin
				readln(F,ss);
				psg := pos(' | ',ss)-1;
				if (T.TDF[i].Judul = copy(ss,1,psg)) then
				begin
					len := length(copy(ss,1,psg))+3;
					delete(ss,1,len);				
					val(copy(ss,26,2),T.TDF[i].Tayang.Tanggal[j].TJ[k].SisaKursi);
					k := k + 1;
					if (k = 5) then
					begin
						k := 1;
						j := j + 1;
						if (j = T.TDF[i].Tayang.Hari + 1) then
						begin
							j := 1;
						end;
					end;
				end else
				begin
					i := i + 1;
					psg := pos(' | ',ss)-1;
					len := length(copy(ss,1,psg))+3;
					delete(ss,1,len);
					val(copy(ss,26,2),T.TDF[i].Tayang.Tanggal[j].TJ[k].SisaKursi);
					k := k + 1;
				end;
			end;
		Close(F);

		Assign(F, 'DataPembeli.txt');
		Reset(F);
		i := 0;
		while(not(EOF(F))) do
		begin
			readln(F,ss);
			i := i + 1;
			psg := pos(' | ',ss)-1;
			M.TDM[i].Username:=copy(ss,1,psg);
			len := length(copy(ss,1,psg))+3;
			delete(ss,1,len);			

			psg := pos(' | ',ss)-1;
			M.TDM[i].Password:=copy(ss,1,psg);
			len := length(copy(ss,1,psg))+3;
			delete(ss,1,len);

			val(ss,M.TDM[i].Saldo);
		end;			
		M.Neff := i;
		close(F);

		Assign(F,'TanggalHariIni.txt'); // Load Tanggal Hari ini
		Reset(F);

			readln(F,ss);

			psg := pos(' | ',ss)-1;
			val(copy(ss,1,psg),S.Tanggal); // Tanggal
			len := length(copy(ss,1,psg))+3;
			delete(ss,1,len);			

			psg := pos(' | ',ss)-1;
			val(copy(ss,1,psg),S.Bulan); // Bulan
			len := length(copy(ss,1,psg))+3;
			delete(ss,1,len);

			val(copy(ss,1,4),S.Tahun); // Tahun
			len := length(copy(ss,1,psg))+3;
			delete(ss,1,len);

			S.Hari := ss; // Hari

		Close(F);

		writeln('> Pembacaan file berhasil');
	end;

FUNCTION Kabisat (S : TTanggal) : Boolean;
	
	begin
		if (S.Tahun mod 400 = 0) then
		begin
			Kabisat := true;
		end else if (S.Tahun mod 100 = 0) then
		begin
			Kabisat := false;
		end else if (S.Tahun mod 4 = 0) then
		begin
			Kabisat := true;
		end else Kabisat := false;
	end;

PROCEDURE F2nowPlaying (T: TabFilm; S:TTanggal);

	var
		count : integer;

	begin
		count := 0;
		for i:=1 to T.FNeff do
		begin
			if (T.TDF[i].Tayang.Tahun = S.Tahun ) then
			begin
				if (T.TDF[i].Tayang.Bulan = S.Bulan) then
				begin
					for j:= T.TDF[i].Tayang.ATanggal to (T.TDF[i].Tayang.ATanggal + T.TDF[i].Tayang.Hari - 1) do
					begin
						if (j = S.Tanggal) then	
						begin
							count := count + 1;
							writeln('> ',count,'. ',T.TDF[i].Judul);
						end;
					end;
				end;
			end;
		end;
		if count = 0 then writeln('> Maaf, tidak ada film yang tayang hari ini.')
	end;

PROCEDURE F3upComing (T: TabFilm; S:TTanggal);

	var
		count : integer;

	begin
		S.Tanggal := S.Tanggal + 7;
		if (S.Bulan = 1) or (S.Bulan = 3) or (S.Bulan = 5) or (S.Bulan = 7) or (S.Bulan = 8) or (S.Bulan = 10) or (S.Bulan = 12) then
		begin
			if (S.Tanggal > 31) then
			begin
				if (S.Bulan = 12) then
				begin
					S.Tanggal := S.Tanggal - 31;
					S.Bulan := 1;
					S.Tahun := S.Tahun + 1;
				end else
				begin
					S. Bulan := S.Bulan + 1;
					S.Tanggal := S.Tanggal - 31;
				end;
			end;
		end else
		if (S.Bulan = 4) or (S.Bulan = 6) or (S.Bulan = 9) or (S.Bulan = 11) then
		begin
			if (S.Tanggal > 30) then
			begin
				S.Bulan := S.Bulan + 1;
				S.Tanggal := S.Tanggal - 30;
			end;
		end else // Bulan Februari
		begin
			if (Kabisat(S) = true) then
			begin
				if (S.Tanggal > 29) then
				begin
					S.Tanggal := S.Tanggal - 29;
					S.Bulan := 3;
				end;
			end else
			begin
				if (S.Tanggal > 28) then
				begin
					S.Tanggal := S.Tanggal - 28;
					S.Bulan := 3;
				end;
			end;
		end;
		begin
		count := 0;
			for i:=1 to T.FNeff do
			begin
				if (T.TDF[i].Tayang.Tahun = S.Tahun ) then
				begin
					if (T.TDF[i].Tayang.Bulan = S.Bulan) then
					begin
						for j:= T.TDF[i].Tayang.ATanggal to (T.TDF[i].Tayang.ATanggal + T.TDF[i].Tayang.Hari - 1) do
						begin
							if (j = S.Tanggal) then
							begin
								count := count + 1;
								writeln('> ',count,'. ',T.TDF[i].Judul);
							end;
						end;
					end;
				end;
			end;
		end;
		if count = 0 then writeln('> Maaf, tidak ada film yang tayang minggu depan.')
	end;

PROCEDURE F4schedule (T: TabFilm);

	var
		inFilm : string;
		inTanggal : integer;
		count : integer;

	begin
		count := 0;
		write('> Masukkan Nama Film : ');readln(inFilm);
		write('> Masukkan Tanggal Penayangan : ');readln(inTanggal);
		for i := 1 to T.FNeff do
		begin
			for j := T.TDF[i].Tayang.ATanggal to T.TDF[i].Tayang.ATanggal + T.TDF[i].Tayang.Hari - 1 do
			begin
				for k := 1 to 4 do
				begin
					if (T.TDF[i].Judul = inFilm) and (j = inTanggal) then
					begin
						count := count + 1;
						writeln('> Jam Tayang ke-',k,' : ',T.TDF[i].Tayang.Tanggal[j-T.TDF[i].Tayang.ATanggal+1].TJ[k].Jam);
					end;
	    		end;
	    	end;
	    end;	
		if count = 0 then writeln('> Maaf, Tidak didapatkan film dengan nama ',inFilm,' yang tayang pada tanggal ',inTanggal,'.')
	end;

PROCEDURE F5genreFilter (T: TabFilm);

	var
		count : integer;
		inGenre : string;

	begin
		count := 0;
		write('> Masukkan genre yang diinginkan : ');readln(inGenre);
		for i := 1 to T.FNeff do
		begin
			if (T.TDF[i].Genre = inGenre) then
			begin
				writeln('> ',count + 1,'. ',T.TDF[i].Judul);
				count := count + 1;
			end;
		end;
		if (count = 0) then writeln('> Maaf, tidak ditemukan film dengan genre ',inGenre,'.');
	end;

PROCEDURE F6ratingFilter (T: TabFilm);

	var
		count : integer;
		inRating : string;

	begin
		count := 0;
		write('> Masukkan rating yang diinginkan : ');readln(inRating);
		for i := 1 to T.FNeff do
		begin
			if (T.TDF[i].Rating = inRating) then
			begin
				writeln('> ',count + 1,'. ',T.TDF[i].Judul);
				count := count + 1;
			end;
		end;
		if (count = 0) then writeln('> Maaf, tidak ditemukan film dengan rating ',inRating,'.');
	end;

PROCEDURE F7searchMovie (T: TabFilm);

	var
		Keywoard : string;
		psg : integer;
		count,n : integer;

	begin
		n := 0;
		write('> Masukkan Keywoard pada film yang ingin dicari : ');readln(Keywoard);
		for i := 1 to T.FNeff do
		begin
			count := 0;
			psg := pos(Keywoard,T.TDF[i].Judul);
			count := count + psg;
			psg := pos(Keywoard,T.TDF[i].Genre);
			count := count + psg;
			psg := pos(Keywoard,T.TDF[i].Sinopsis);
			count := count + psg;
			if (count > 0) then 
			begin
				writeln('> Kata "',Keywoard,'" ada pada film ',T.TDF[i].Judul,'.');				
				n := n + 1;
			end;
		end;
		if (n=0) then writeln('> Kata "',Keywoard,'" tidak ditemukan di semua film.');
	end;

PROCEDURE F8showMovie (T: TabFilm);

	var
		inFilm : string;
		found : Boolean;

	begin
		found := true;
		write('> Masukkan Nama Film : ');readln(inFilm);
		for i := 1 to T.FNeff do
		begin
			if (T.TDF[i].Judul = inFilm) then
			begin
				writeln('> Nama : ',T.TDF[i].Judul);
				writeln('> Genre : ',T.TDF[i].Genre);
				writeln('> Rating : ',T.TDF[i].Rating);
				writeln('> Durasi : ',T.TDF[i].Durasi);
				writeln('> Sinopsis : ',T.TDF[i].Sinopsis);
				writeln('> Harga weekdays : ',T.TDF[i].Harga.WD,' Rupiah');
				writeln('> Harga weekends : ',T.TDF[i].Harga.WE,' Rupiah');
				writeln('> Tanggal mulai tayang : ',T.TDF[i].Tayang.ATanggal,'-',T.TDF[i].Tayang.Bulan,'-',T.TDF[i].Tayang.Tahun);
				writeln('> Lama tayang : ',T.TDF[i].Tayang.Hari,' Hari');				
				for j:=1 to 4 do
				begin
					writeln('> Jam tayang ke-',j,' : ',T.TDF[i].Tayang.Tanggal[i].TJ[j].Jam);
				end;
				found := false;
			end;
		end;
		if (found) then writeln('> Maaf, tidak ditemukan film dengan nama ',inFilm,'.');
	end;

PROCEDURE F9showNextDay (T: TabFilm; S:TTanggal);

	begin
		if (S.Bulan = 1) or (S.Bulan = 3) or (S.Bulan = 5) or (S.Bulan = 7) or (S.Bulan = 8) or (S.Bulan = 10) or (S.Bulan = 12) then
		begin

			if (S.Tanggal = 31) then
			begin
				if (S.Bulan = 12 ) then
				begin
					S.Tahun := S.Tahun + 1;
					S.Bulan := 1;
				end else
				begin
					S.Bulan := S.Bulan + 1;
				end;
				S.Tanggal := 1;
			end else S.Tanggal := S.Tanggal + 1;

		end else
		if (S.Bulan = 4) or (S.Bulan = 6) or (S.Bulan = 9) or (S.Bulan = 11) then
		begin
			if (S.Tanggal = 30) then
			begin
				S.Tanggal := 1;
				S.Bulan := S.Bulan + 1;
			end else S.Tanggal := S.Tanggal + 1;
		end else // Bulan Februari
		begin
			if (Kabisat(S) = true) then
			begin
				if (S.Tanggal = 29) then
				begin
					S.Tanggal := 1;
					S.Bulan := 3;
				end else S.Tanggal := S.Tanggal + 1;
			end else
			begin
				if (S.Tanggal = 28) then
				begin
					S.Tanggal := 1;
					S.Bulan := 3;
				end else S.Tanggal := S.Tanggal + 1;
			end;
		end;

		for i:=1 to T.FNeff do
		begin
			if (T.TDF[i].Tayang.Tahun = S.Tahun ) then
			begin
				if (T.TDF[i].Tayang.Bulan = S.Bulan) then
				begin
					for j:= T.TDF[i].Tayang.ATanggal to (T.TDF[i].Tayang.ATanggal + T.TDF[i].Tayang.Hari - 1) do
					begin
						if (j = S.Tanggal) then	writeln('> ',T.TDF[i].Judul);
					end;
				end;
			end;
		end;
	end;

PROCEDURE F10selectMovie (T: TabFilm; S:TTanggal);

	var
		F,F1 : text;
		inFilm, inJam, inTanggal, ss, blns, tgls : string;
		found : boolean;
		tgl, bln, thn, inTiket, no, tl : integer;
		harga : longint;

	begin

		found := false;
		write('> Film: ');readln(inFilm);
		repeat
			for i := 1 to T.FNeff do
			begin 
				if T.TDF[i].Judul = inFilm then
				begin
					found := true;
				end;
			end;
			if not(found) then
			begin
				write('> Film tidak ditemukan, silahkan masukkan ulang nama film: ');
				readln(inFilm);
			end;
		until found = true;
	
		repeat
			write('> Tanggal tayang: ');readln(inTanggal);
			if length(inTanggal)<>10 then writeln('> Format masukan salah, format masukan: dd-mm-yyyy');
			tgls := copy(inTanggal,1,2);
			blns := copy(inTanggal,4,2);
			val(tgls,tgl);
			val(blns,bln);
			val(copy(inTanggal,7,4),thn);
			if (tgl>31) or (bln>12) then writeln('> Tanggal tidak boleh melebihi 31 dan bulan tidak boleh melebihi 12.')
		until (length(inTanggal)=10) and (tgl<32) and (bln<13);	

		if (bln = 1) or (bln = 3) or (bln = 5) or (bln = 7) or (bln = 8) or (bln = 10) or (bln = 12) then
		begin
			if (S.bulan < bln) then tgl := tgl + 30;
		end else
		begin
			if (S.bulan < bln) then tgl := tgl + 31;
		end;
		if S.Tanggal > tgl then
		begin
			tl := S.Tanggal - tgl;
			while (tl >= 7) do
			begin
				tl := tl - 7;
			end;
		end else
		begin
			tl := tgl - S.Tanggal;
			while (tl >= 7) do
			begin
				tl := tl - 7;
			end;
		end;

		write('> Jam tayang: ');readln(inJam);
		for i := 1 to T.FNeff do
		begin
			if (T.TDF[i].Judul = inFilm) then
			begin
				if (T.TDF[i].Tayang.Tahun = thn ) then
				begin
					if (T.TDF[i].Tayang.Bulan = bln) then
					begin
						for j := T.TDF[i].Tayang.ATanggal to (T.TDF[i].Tayang.ATanggal + T.TDF[i].Tayang.Hari - 1) do
						begin
							if j = tgl then
							begin
								for k := 1 to 4 do
								begin
									if T.TDF[i].Tayang.Tanggal[j - T.TDF[i].Tayang.ATanggal].TJ[k].Jam = inJam then
									begin
										writeln('> Kapasitas tersisa: ',T.TDF[i].Tayang.Tanggal[j - T.TDF[i].Tayang.ATanggal].TJ[k].SisaKursi,' orang');
									    repeat
											write('> Masukan jumlah tiket yang ingin dibeli: ');readln(inTiket);
											if (inTiket < 1) or (inTiket > T.TDF[i].Tayang.Tanggal[j - T.TDF[i].Tayang.ATanggal].TJ[k].SisaKursi) then
											begin
												writeln('> Tiket harus diantara 1 sampai dengan kapasitas kursi yang tersisa.');
											end;
										until (inTiket > 0) and (inTiket <= T.TDF[i].Tayang.Tanggal[j - T.TDF[i].Tayang.ATanggal].TJ[k].SisaKursi);
										
											case tl of
												0 : {S.Hari := 'Rabu'} harga := T.TDF[i].Harga.WD * inTiket;
												1 : {S.Hari := 'Kamis'} harga := T.TDF[i].Harga.WD * inTiket;
												2 : {S.Hari := 'Jumat'} harga := T.TDF[i].Harga.WD * inTiket;
												3 : {S.Hari := 'Sabtu'}  harga := T.TDF[i].Harga.WE * inTiket;
												4 : {S.Hari := 'Minggu'} harga := T.TDF[i].Harga.WE * inTiket;
												5 : {S.Hari := 'Senin'} harga := T.TDF[i].Harga.WD * inTiket;
												6 : {S.Hari := 'Selasa'} harga := T.TDF[i].Harga.WD * inTiket;
											end; 	


										Assign(F,'DataPemesanan.txt'); // Load Data Pemesanan untuk mendapatkan nomor pemesanan
										Assign(F1,'DataPemesanannDummy.txt');
										
										Reset(F);
										rewrite(F1);
										
										while (not(EOF(F))) do
										begin
											readln(F,ss); writeln(F1,ss);
											val(copy(ss,1,3),no);
										end;
									
										no := no + 1;
										if no < 10 then write(F1, '00',no,' | ',inFilm,' | ',tgls,' | ',blns,' | ',thn,' | ',inJam,' | ',inTiket,' | ',harga,' | Belum dibayar');
										if (no > 9) and (no < 100) then write(F1, '0',no,' | ',inFilm,' | ',tgls,' | ',blns,' | ',thn,' | ',inJam,' | ',inTiket,' | ',harga,' | Belum dibayar');
										if (no > 99) then write(F1, no,' | ',inFilm,' | ',tgls,' | ',blns,' | ',thn,' | ',inJam,' | ',inTiket,' | ',harga,' | Belum dibayar');

										close(F);
										close(F1);

										//Menulis ulang dari Dummy ke Asli
										Assign(F,'DataPemesanan.txt');
										Assign(F1,'DataPemesanannDummy.txt');
										
										Reset(F1);
										rewrite(F);

										while (not(EOF(F1))) do
										begin
											readln(F1,ss);
											writeln(F,ss);
										end;

										close(F);
										close(F1);

										if (no < 10) then writeln('> Pemesanan sukses, nomor pemesanan Anda adalah: 00',no);
										if (no > 9) and (no < 100) then writeln('> Pemesanan sukses, nomor pemesanan Anda adalah: 0',no);
										if (no > 99) then writeln('> Pemesanan sukses, nomor pemesanan Anda adalah: ',no);
									end;
								end;
							end;		
						end;
					end;
				end;
	    	end;
	    end;

	end;

PROCEDURE F11payCreditCard (T : TabFilm);

	var
		F : text;
		noKredit, noPesan, JenisBayar, ss : string;
		psg, len, noPesanI : integer;
		harga : longint;
		DM : Array [1..100] of string;
		judul, tanggal, bulan, tahun, jam, ntiket, hargaS : string;

	begin
		i := 0;
		write('> Nomor pemesanan : ');readln(noPesan);
		val(noPesan,noPesanI); // string ke integer
		Assign(F,'DataPemesanan.txt');
		Reset(F);
		while (not(EOF(F))) do
		begin
			i := i + 1;
			readln(F,ss);
			DM[i] := ss;
			if (copy(ss,1,3)=noPesan) then
			begin
				for j := 1 to 7 do // ada 6 guard sebelum harga
				begin
					psg := pos(' | ',ss) - 1;
					case j of
						2 : judul := copy(ss,1,psg);
						3 : tanggal := copy(ss,1,psg);
						4 : bulan := copy(ss,1,psg);
						5 : tahun := copy(ss,1,psg);
						6 : jam := copy(ss,1,psg);
						7 : ntiket := copy(ss,1,psg);
					end;
					len := length(copy(ss,1,psg))+3;
					delete(ss,1,len);
				end;
				psg := pos(' | ',ss) - 1;
				hargaS := copy(ss,1,psg);
				val(hargaS,harga);
			end;
		end;
		close(F);

		writeln('> Harga tiket yang harus dibayar : ',harga);
		write('> Nomor kartu kredit : ');readln(noKredit);
		if (length(noKredit) = 15) then
		begin
			writeln('> Pembayaran sukses!');
			JenisBayar := 'Kartu Kredit';
			// Kurangi kapasitas
			{Data kapasitas yang Sisa kursi - Data pemesanan tiket}
		end else writeln('> Nomor kartu invalid!');

		DM[noPesanI] := concat(noPesan,' | ',judul,' | ',tanggal,' | ',bulan,' | ',tahun,' | ',jam,' | ',ntiket,' | ',hargaS,' | ',JenisBayar);
		Assign(F,'DataPemesanan.txt');
		rewrite(F);
		for j:=1 to i do
		begin
			writeln(F,DM[j])
		end;
		close(F);

	end;

FUNCTION F13loginMember (username,password : string) : boolean;

	begin
		for i := 1 to M.Neff do
		begin
			if (M.TDM[i].Username = username) and (M.TDM[i].Password = password) then
				F13loginMember := true
			else
				F13loginMember := false;
		end;
	end;

PROCEDURE F12payMember (T : TabFilm; M : TabDataMember);
	
	var
		F : text;
		noPesan, JenisBayar, ss : string;
		psg, len, noPesanI : integer;
		harga : int64;
		DM : Array [1..100] of string;
		judul, tanggal, bulan, tahun, jam, ntiket, hargaS : string;	
		username, password : string;
	begin

		writeln('> Gunakan akun member Anda dan dapatkan cashback sebesar 10% !');
		write('> Masukkan username member anda : ');readln(username);
		write('> Masukkan password member anda : ');readln(password);
		if (F13loginMember(username,password) = true ) then
		begin
			writeln('> Login sukses!');

			i := 0;
			write('> Nomor pemesanan : ');readln(noPesan);
			val(noPesan,noPesanI); // string ke integer
			Assign(F,'DataPemesanan.txt');
			Reset(F);
			while (not(EOF(F))) do
			begin
				i := i + 1;
				readln(F,ss);
				DM[i] := ss;
				if (copy(ss,1,3)=noPesan) then
				begin
					for j := 1 to 7 do // ada 6 guard sebelum harga
					begin
						psg := pos(' | ',ss) - 1;
						case j of
							2 : judul := copy(ss,1,psg);
							3 : tanggal := copy(ss,1,psg);
							4 : bulan := copy(ss,1,psg);
							5 : tahun := copy(ss,1,psg);
							6 : jam := copy(ss,1,psg);
							7 : ntiket := copy(ss,1,psg);
						end;
						len := length(copy(ss,1,psg))+3;
						delete(ss,1,len);
					end;
					psg := pos(' | ',ss) - 1;
					hargaS := copy(ss,1,psg);
					val(hargaS,harga);
				end;
			end;
			close(F);


			for k := 1 to M.Neff do
			begin
				if (M.TDM[k].Username = username) then
				begin
					writeln('> Sisa saldo anda : ',M.TDM[k].Saldo);
					if (M.TDM[k].Saldo >= harga) then
					begin
						M.TDM[k].Saldo := M.TDM[k].Saldo - (harga * 90 div 100);
						writeln('> Pemesanan berhasil! Saldo anda berkurang : ',harga);
						writeln('> Anda mendapatkan cashback sebesar : ',(harga * 10 div 100));
						writeln('> Sisa saldo anda : ',M.TDM[k].Saldo);
						JenisBayar := 'Member';
						
						DM[noPesanI] := concat(noPesan,' | ',judul,' | ',tanggal,' | ',bulan,' | ',tahun,' | ',jam,' | ',ntiket,' | ',hargaS,' | ',JenisBayar);
					
						//Kurangi kapasitas
						{Data kapasitas yang Sisa kursi - Data pemesanan tiket}
					end else writeln('> Saldo tidak mencukupi, mohon bayar menggunakan metode yang lain');
				end;
			end;

			Assign(F,'DataPemesanan.txt'); // Tulis ulang ke file
			rewrite(F);
			for j:=1 to i do
			begin
				writeln(F,DM[j])
			end;
			close(F);

			assign(F,'DataPembeli.txt');
			rewrite(F);
			for i := 1 to M.Neff do
			begin
				writeln(F,M.TDM[i].Username,' | ',M.TDM[i].Password,' | ',M.TDM[i].Saldo);
			end;
			close(F);			

		end else writeln('> Login gagal! Password atau username yang dimasukkan salah! Silahkan Daftar terlebih dahulu');	
	end;

PROCEDURE F14register (var M : TabDataMember);

	var
		F : text;
		ss : string;
	begin
		M.Neff := 0;
		Assign(F,'DataPembeli.txt');
		reset(F);
		while (not(EOF(F))) do
		begin
			readln(F,ss);
			M.Neff := M.Neff + 1;
		end;
		close(F);
		M.Neff := M.Neff + 1;
		write('> Masukkan username member baru anda : ');readln(M.TDM[M.Neff].Username);
		write('> Masukkan password member baru anda : ');readln(M.TDM[M.Neff].Password);
		M.TDM[M.Neff].Saldo := 100000;
		writeln('> Selamat! Anda telah bergabung menjadi member baru! Saldo anda 100.000 Rupiah');
	
		assign(F,'DataPembeli.txt');
		rewrite(F);
		for i := 1 to M.Neff do
		begin
			writeln(F,M.TDM[i].Username,' | ',M.TDM[i].Password,' | ',M.TDM[i].Saldo);
		end;
		close(F);

	end;

PROCEDURE F15exit ();

	begin
		
		writeln('/----------------------------------------------------------------------------\');
		writeln('|             Terima kasih sudah menggunakan aplikasi kami ^_^               |');
		writeln('\----------------------------------------------------------------------------/');
		writeln('                Iswan Aulia ..................... 16515035');
		writeln('                Muthahhari Aulia Padmanagara .... 16515154');
		writeln('                Achmad Fahrurrozi Maskur ........ 16515266');
		writeln('                Frits Elwildo ................... 16515301');
		writeln('                Aries Adjie Pangestu ............ 16515336');
		writeln('                Oktavianus Handika .............. 16515376');
		writeln('\----------------------------------------------------------------------------/');

	end;

{PROGRAM UTAMA}
BEGIN

	T.FNeff := 0;
	M.Neff := 0;
	TampilMenu();
	write('> Masukkan pilihan : ');readln(pilihan);
	if (pilihan = 'exit') or (pilihan = '14') then F15exit()
	else
	begin
		while ((pilihan <> 'load') and (pilihan <> '1')) and (T.FNeff = 0) do
		begin
			writeln('> Maaf, belum ada data, pilih load terlebih dahulu');
			write('> Masukkan pilihan : ');readln(pilihan);
			if (pilihan = 'exit') or (pilihan = '14') then F15exit();
		end;

	if (pilihan = 'load') or (pilihan = '1') then F1load(T,S,M);

		repeat
				write('> Masukkan pilihan : ');readln(pilihan);
				if (pilihan = 'exit') or (pilihan = '14') then
				begin
					x := 'N';
				end else if (pilihan <> 'exit') and (pilihan <> '14') then
				begin
					if (pilihan = 'load') or (pilihan = '1') then F1load(T,S,M)
					else if (pilihan = 'nowPlaying') or (pilihan = '2') then F2nowPlaying(T,S)
					else if (pilihan = 'upComing') or (pilihan = '3') then F3upComing(T,S)
					else if (pilihan = 'schedule') or (pilihan = '4') then F4schedule(T)
					else if (pilihan = 'genreFilter') or (pilihan = '5') then F5genreFilter(T)
					else if (pilihan = 'ratingFliter') or (pilihan = '6') then F6ratingFilter(T)
					else if (pilihan = 'searchMovie') or (pilihan = '7') then F7searchMovie(T)
					else if (pilihan = 'showMovie') or (pilihan = '8') then F8showMovie(T)
					else if (pilihan = 'showNextDay') or (pilihan = '9') then F9showNextDay(T,S)
					else if (pilihan = 'selectMovie') or (pilihan = '10') then F10selectMovie(T,S)
					else if (pilihan = 'payCreditCard') or (pilihan = '11') then F11payCreditCard(T)
					else if (pilihan = 'payMember') or (pilihan = '12') then F12payMember(T,M)
					else if (pilihan = 'register') or (pilihan = '13') then F14register(M)
					else writeln('> Masukan salah, pilih menu kembali');
					
					write('> Lanjutkan ke pilihan menu? (Y/N) --> '); readln(x);
					
					while ((x <> 'Y') and (x <> 'y')) and ((x <> 'N') and (x <> 'n')) do
					begin
						write('Pilih Y atau N. Lanjutkan ke pilihan menu? ');readln(x);
					end;
					
					writeln();
					if (x <> 'N') and (x <> 'n') then TampilMenu();
			
				end;
		until (x = 'N') or (x = 'n');
		if (x = 'N') or (x = 'n') then F15exit();
		
	end;

END.