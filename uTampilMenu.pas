unit uTampilMenu;

interface
	procedure TampilMenu();

implementation
	procedure TampilMenu();
	{I.S. Tidak ada Var Input}
	{F.S. Menampilkan pilihan menu di layar}
	begin
		writeln('/----------------------------------------------------------------------------\');
		writeln('|             SELAMAT DATANG DI APLIKASI PEMBELIAN TIKET BIOSKOP             |');
		writeln('\----------------------------------------------------------------------------/');
		writeln(' PILIHAN MENU =');
		writeln(' 1. load           : Membaca data dari file eksternal');
		writeln(' 2. nowPlaying     : Menyimpan data ke file eksternal');
		writeln(' 3. upComing       : Menampilkan film yang akan tayang minggu depan');
		writeln(' 4. schedule       : Menampilkan jam tayang film');
		writeln(' 5. genreFilter    : Menampilkan film sesuai genre');
		writeln(' 6. ratingFliter   : Menampilkan film sesuai rating');
		writeln(' 7. searchMovie    : Mencari film berdasarkan keyword (judul, genre, sinopsis)');
		writeln(' 8. showMovie      : Menampilkan deskripsi film');
		writeln(' 9. showNextDay    : Menampilkan film yang tayang besok hari');
		writeln(' 10. selectMovie   : Memilih film yang ingin di tonton');
		writeln(' 11. payCreditCard : Bayar tiket dengan Kartu Kredit');
		writeln(' 12. payMember     : Bayar tiket dengan akun member');
		writeln(' 13. register      : Mendaftar menjadi member');
		writeln(' 14. exit          : Keluar dari program');
		writeln('\----------------------------------------------------------------------------/');
	end;
end.	