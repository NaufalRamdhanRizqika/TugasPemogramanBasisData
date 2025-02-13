<?php
class view
{
    protected $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function pegawai()
    {
        $sql = "SELECT pegawai.*, login.user, login.pass FROM pegawai INNER JOIN login ON pegawai.id_pegawai = login.id_pegawai";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetchAll();
    }

    public function pegawai_edit($id)
    {
        $sql = "SELECT pegawai.*, login.user, login.pass FROM pegawai INNER JOIN login ON pegawai.id_pegawai = login.id_pegawai WHERE pegawai.id_pegawai = ?";
        $row = $this->db->prepare($sql);
        $row->execute([$id]);
        return $row->fetch();
    }

    public function toko()
    {
        $sql = "SELECT * FROM toko WHERE id_toko = '1'";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetch();
    }

    public function kategori()
    {
        $sql = "SELECT id_kategori, nama_kategori, tgl_input FROM kategori";
        $query = $this->db->prepare($sql);
        $query->execute();
        return $query->fetchAll();
    }


    public function barang()
    {
        $sql = "SELECT barang.*, kategori.id_kategori, kategori.nama_kategori FROM barang INNER JOIN kategori ON barang.id_kategori = kategori.id_kategori ORDER BY id_barang DESC";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetchAll();
    }

    public function barang_stok()
    {
        $sql = "SELECT barang.*, kategori.id_kategori, kategori.nama_kategori FROM barang INNER JOIN kategori ON barang.id_kategori = kategori.id_kategori WHERE stok <= 3 ORDER BY id_barang DESC";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetchAll();
    }

    public function barang_edit($id)
    {
        $sql = "SELECT barang.*, kategori.id_kategori, kategori.nama_kategori FROM barang INNER JOIN kategori ON barang.id_kategori = kategori.id_kategori WHERE id_barang = ?";
        $row = $this->db->prepare($sql);
        $row->execute([$id]);
        return $row->fetch();
    }

    public function barang_cari($cari)
    {
        $sql = "SELECT barang.*, kategori.id_kategori, kategori.nama_kategori FROM barang INNER JOIN kategori ON barang.id_kategori = kategori.id_kategori WHERE id_barang LIKE ? OR nama_barang LIKE ? OR merk LIKE ?";
        $row = $this->db->prepare($sql);
        $row->execute(["%$cari%", "%$cari%", "%$cari%"]);
        return $row->fetchAll();
    }

    public function barang_id()
    {
        $sql = 'SELECT * FROM barang ORDER BY id_barang DESC';
        $row = $this->db->prepare($sql);
        $row->execute();
        $hasil = $row->fetch();

        $urut = substr($hasil['id_barang'], 2, 3);
        $tambah = (int) $urut + 1;
        if (strlen($tambah) == 1) {
            $format = 'BR00' . $tambah . '';
        } elseif (strlen($tambah) == 2) {
            $format = 'BR0' . $tambah . '';
        } else {
            $ex = explode('BR', $hasil['id_barang']);
            $no = (int) $ex[1] + 1;
            $format = 'BR' . $no . '';
        }
        return $format;
    }

    public function kategori_edit($id)
    {
        $sql = "SELECT * FROM kategori WHERE id_kategori = ?";
        $row = $this->db->prepare($sql);
        $row->execute([$id]);
        return $row->fetch();
    }

    public function kategori_row()
    {
        $sql = "SELECT * FROM kategori";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->rowCount();
    }

    public function barang_row()
    {
        $sql = "SELECT * FROM barang";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->rowCount();
    }

    public function barang_stok_row()
    {
        $sql = "SELECT SUM(stok) as jml FROM barang";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetch();
    }

    public function barang_beli_row()
    {
        $sql = "SELECT SUM(harga_beli) as beli FROM barang";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetch();
    }

    public function jual_row()
    {
        $sql = "SELECT SUM(jumlah) as stok FROM nota";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetch();
    }

    public function jual()
    {
        $sql = "SELECT nota.*, barang.id_barang, barang.nama_barang, barang.harga_beli, pegawai.id_pegawai, pegawai.nm_pegawai FROM nota LEFT JOIN barang ON barang.id_barang = nota.id_barang LEFT JOIN pegawai ON pegawai.id_pegawai = nota.id_pegawai WHERE nota.periode = ? ORDER BY id_nota DESC";
        $row = $this->db->prepare($sql);
        $row->execute([date('m-Y')]);
        return $row->fetchAll();
    }

    public function periode_jual($periode)
    {
        $sql = "SELECT nota.*, barang.id_barang, barang.nama_barang, barang.harga_beli, pegawai.id_pegawai, pegawai.nm_pegawai FROM nota LEFT JOIN barang ON barang.id_barang = nota.id_barang LEFT JOIN pegawai ON pegawai.id_pegawai = nota.id_pegawai WHERE nota.periode = ? ORDER BY id_nota ASC";
        $row = $this->db->prepare($sql);
        $row->execute([$periode]);
        return $row->fetchAll();
    }

    public function hari_jual($hari)
    {
        $ex = explode('-', $hari);
        $monthNum = $ex[1];
        $monthName = date('F', mktime(0, 0, 0, $monthNum, 10));
        if ($ex[2] > 9) {
            $tgl = $ex[2];
        } else {
            $tgl1 = explode('0', $ex[2]);
            $tgl = $tgl1[1];
        }
        $cek = $tgl . ' ' . $monthName . ' ' . $ex[0];
        $param = "%{$cek}%";
        $sql = "SELECT nota.*, barang.id_barang, barang.nama_barang, barang.harga_beli, pegawai.id_pegawai, pegawai.nm_pegawai FROM nota LEFT JOIN barang ON barang.id_barang = nota.id_barang LEFT JOIN pegawai ON pegawai.id_pegawai = nota.id_pegawai WHERE nota.tanggal_input LIKE ? ORDER BY id_nota ASC";
        $row = $this->db->prepare($sql);
        $row->execute([$param]);
        return $row->fetchAll();
    }

    public function penjualan()
    {
        $sql = "SELECT penjualan.*, barang.id_barang, barang.nama_barang, pegawai.id_pegawai, pegawai.nm_pegawai FROM penjualan LEFT JOIN barang ON barang.id_barang = penjualan.id_barang LEFT JOIN pegawai ON pegawai.id_pegawai = penjualan.id_pegawai ORDER BY id_penjualan";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetchAll();
    }

    public function jumlah()
    {
        $sql = "SELECT SUM(total) as bayar FROM penjualan";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetch();
    }

    public function jumlah_nota()
    {
        $sql = "SELECT SUM(total) as bayar FROM nota";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetch();
    }

    public function jml()
    {
        $sql = "SELECT SUM(harga_beli * stok) as byr FROM barang";
        $row = $this->db->prepare($sql);
        $row->execute();
        return $row->fetch();
    }
}
