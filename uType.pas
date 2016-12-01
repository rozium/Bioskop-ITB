unit uType;

interface

const 
	NMax = 10;

type

	THarga = record
		WE : longint;
		WD : longint;
	end;

	TKursi = record
		Jam : string;
		SisaKursi : integer;
	end;	

	TJam = record
		TJ : Array[1..4] of TKursi;
	end;

	TTayang = record
		Tanggal : Array[1..30] of TJam;
		ATanggal : integer;
		Bulan : integer;
		Tahun : integer;
		Hari : integer;
	end;

	TTanggal = record
		Tanggal : integer;
		Bulan : integer;
		Tahun : integer;
		Hari : string;
	end;

	DataFilm = record
		Judul : string;
		Genre : string;
		Rating : string;
		Sinopsis : ansistring;
		Durasi : string;
		Harga : THarga;
		Tayang : TTayang;
	end;

	TabFilm = record
		TDF : Array [1..NMax] of DataFilm;
		FNeff : integer;
	end;

	DataMember = record
		Username : string;
		Password : string;
		Saldo : int64;
	end;

	TabDataMember = record
		TDM : Array [1..NMax] of DataMember;
		Neff : integer;
	end;

implementation
end.