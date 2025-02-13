<?php
session_start();
if (!empty($_SESSION['admin'])) {
    require '../../config.php';

    if (!empty($_POST['kategori'])) {
        $kategori = $_POST['kategori'];
        $sql = "INSERT INTO kategori (nama_kategori, tgl_input) VALUES (?, NOW())";
        $row = $config->prepare($sql);
        $row->execute(array($kategori));
        echo '<script>window.location="../../index.php?page=kategori&success=tambah-data"</script>';
    }

    if (!empty($_GET['barang'])) {
        $id = htmlentities($_POST['id']);
        $kategori = htmlentities($_POST['kategori']);
        $nama = htmlentities($_POST['nama']);
        $merk = htmlentities($_POST['merk']);
        $beli = htmlentities($_POST['beli']);
        $jual = htmlentities($_POST['jual']);
        $satuan = htmlentities($_POST['satuan']);
        $stok = htmlentities($_POST['stok']);
        $tgl_input = date("Y-m-d H:i:s");

        $data = [$id, $kategori, $nama, $merk, $beli, $jual, $satuan, $stok, $tgl_input];
        $sql = 'INSERT INTO barang (id_barang, id_kategori, nama_barang, merk, harga_beli, harga_jual, satuan_barang, stok, tgl_input) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
        $row = $config->prepare($sql);
        $row->execute($data);

        echo '<script>window.location="../../index.php?page=barang&success=tambah-data"</script>';
    }


    if (!empty($_GET['jual'])) {
        $id = $_GET['id'];
        $sql = 'SELECT * FROM barang WHERE id_barang = ?';
        $row = $config->prepare($sql);
        $row->execute([$id]);
        $hsl = $row->fetch();

        if ($hsl['stok'] > 0) {
            $kasir = $_GET['id_kasir'];
            $jumlah = 1;
            $total = $hsl['harga_jual'];
            $tgl = date("j F Y, G:i");

            $data1 = [$id, $kasir, $jumlah, $total, $tgl];
            $sql1 = 'INSERT INTO penjualan (id_barang, id_pegawai, jumlah, total, tanggal_input) VALUES (?, ?, ?, ?, ?)';
            $row1 = $config->prepare($sql1);
            $row1->execute($data1);

            echo '<script>window.location="../../index.php?page=jual&success=tambah-data"</script>';
        } else {
            echo '<script>alert("Stok Barang Anda Telah Habis !");window.location="../../index.php?page=jual#keranjang"</script>';
        }
    }
}
