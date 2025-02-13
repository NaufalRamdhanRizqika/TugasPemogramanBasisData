-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 12 Feb 2025 pada 22.55
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_toko`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `HapusBarang` (IN `p_id_barang` VARCHAR(255))   BEGIN
    DELETE FROM barang WHERE id_barang = p_id_barang;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LaporanKategoriStok` (IN `p_kategori` VARCHAR(255), IN `p_min_stok` INT)   BEGIN
    SELECT barang.nama_barang, barang.stok, kategori.nama_kategori
    FROM barang
    JOIN kategori ON barang.id_kategori = kategori.id_kategori
    WHERE kategori.nama_kategori = p_kategori AND barang.stok < p_min_stok;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LaporanStok` (IN `p_min_stok` INT)   BEGIN
    SELECT barang.nama_barang, barang.stok, kategori.nama_kategori
    FROM barang
    JOIN kategori ON barang.id_kategori = kategori.id_kategori
    WHERE barang.stok < p_min_stok;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TambahBarang` (IN `p_id_barang` VARCHAR(255), IN `p_id_kategori` INT, IN `p_nama_barang` TEXT, IN `p_merk` VARCHAR(255), IN `p_harga_beli` VARCHAR(255), IN `p_harga_jual` VARCHAR(255), IN `p_satuan_barang` VARCHAR(255), IN `p_stok` TEXT)   BEGIN
    INSERT INTO barang (id_barang, id_kategori, nama_barang, merk, harga_beli, harga_jual, satuan_barang, stok, tgl_input)
    VALUES (p_id_barang, p_id_kategori, p_nama_barang, p_merk, p_harga_beli, p_harga_jual, p_satuan_barang, p_stok, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateHargaJual` (IN `p_id_barang` VARCHAR(255), IN `p_persen_kenaikan` DECIMAL(5,2))   BEGIN
    UPDATE barang
    SET harga_jual = harga_jual * (1 + p_persen_kenaikan / 100)
    WHERE id_barang = p_id_barang;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStok` (IN `p_id_barang` VARCHAR(255), IN `p_stok_baru` TEXT)   BEGIN
    UPDATE barang
    SET stok = p_stok_baru, tgl_update = NOW()
    WHERE id_barang = p_id_barang;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CekStok` (`p_id_barang` VARCHAR(255)) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE result TEXT;
    SELECT 
        CASE
            WHEN stok > 50 THEN 'Stok Aman'
            WHEN stok BETWEEN 10 AND 50 THEN 'Stok Menipis'
            ELSE 'Stok Habis'
        END INTO result
    FROM barang
    WHERE id_barang = p_id_barang;
    RETURN result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `HitungPendapatan` (`p_jumlah_terjual` INT, `p_harga_jual` DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    RETURN p_jumlah_terjual * p_harga_jual;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `HitungTotalHarga` (`p_harga_jual` DECIMAL(10,2), `p_jumlah` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    RETURN p_harga_jual * p_jumlah;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `RataHargaKategori` (`p_id_kategori` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE rata_rata DECIMAL(10, 2);
    SELECT AVG(harga_jual) INTO rata_rata
    FROM barang
    WHERE id_kategori = p_id_kategori;
    RETURN rata_rata;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `TotalStokKategori` (`p_id_kategori` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total_stok INT;
    SELECT SUM(stok) INTO total_stok
    FROM barang
    WHERE id_kategori = p_id_kategori;
    RETURN total_stok;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `TotalStokMinimum` (`p_id_kategori` INT, `p_min_stok` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;
    SELECT SUM(stok) INTO total
    FROM barang
    WHERE id_kategori = p_id_kategori AND stok > p_min_stok;
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang`
--

CREATE TABLE `barang` (
  `id_barang` varchar(50) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `nama_barang` text NOT NULL,
  `merk` varchar(255) NOT NULL,
  `harga_beli` decimal(10,2) NOT NULL,
  `harga_jual` decimal(10,2) NOT NULL,
  `satuan_barang` varchar(50) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0,
  `tgl_input` datetime NOT NULL DEFAULT current_timestamp(),
  `tgl_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(255) NOT NULL,
  `tgl_input` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `login`
--

CREATE TABLE `login` (
  `id_login` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `pass` char(32) NOT NULL,
  `id_pegawai` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `login`
--

INSERT INTO `login` (`id_login`, `user`, `pass`, `id_pegawai`) VALUES
(1, 'admin', '123', 1),
(2, 'admin123', '1234567', 1),
(4, 'obet', '202cb962ac59075b964b07152d234b70', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_barang`
--

CREATE TABLE `log_barang` (
  `id_log` int(11) NOT NULL,
  `id_barang` varchar(50) NOT NULL,
  `aktivitas` enum('INSERT','UPDATE','DELETE','LOW STOCK','UPDATE HARGA') NOT NULL,
  `waktu` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `nota`
--

CREATE TABLE `nota` (
  `id_nota` int(11) NOT NULL,
  `id_barang` varchar(50) NOT NULL,
  `id_pegawai` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `tanggal_input` datetime NOT NULL DEFAULT current_timestamp(),
  `periode` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pegawai`
--

CREATE TABLE `pegawai` (
  `id_pegawai` int(11) NOT NULL,
  `nm_pegawai` varchar(255) NOT NULL,
  `alamat_pegawai` text NOT NULL,
  `telepon` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `gambar` text NOT NULL,
  `NIK` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pegawai`
--

INSERT INTO `pegawai` (`id_pegawai`, `nm_pegawai`, `alamat_pegawai`, `telepon`, `email`, `gambar`, `NIK`) VALUES
(1, 'Naufal', 'Bandung', '087768909080', 'email@gmail.com', '1739396955people-23.png', '212121222221');

-- --------------------------------------------------------

--
-- Struktur dari tabel `penjualan`
--

CREATE TABLE `penjualan` (
  `id_penjualan` int(11) NOT NULL,
  `id_barang` varchar(50) NOT NULL,
  `id_pegawai` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `tanggal_input` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `toko`
--

CREATE TABLE `toko` (
  `id_toko` int(11) NOT NULL,
  `nama_toko` varchar(255) NOT NULL,
  `alamat_toko` text NOT NULL,
  `tlp` varchar(20) NOT NULL,
  `nama_pemilik` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `toko`
--

INSERT INTO `toko` (`id_toko`, `nama_toko`, `alamat_toko`, `tlp`, `nama_pemilik`) VALUES
(1, 'Warung Pintar', 'Bandung', '0123456789', 'Bu Sulastri');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `viewbarangkategori`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `viewbarangkategori` (
`nama_barang` text
,`nama_kategori` varchar(255)
,`harga_jual` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `viewbarangmahal`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `viewbarangmahal` (
`nama_barang` text
,`harga_jual` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `viewlaporankategori`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `viewlaporankategori` (
`id_kategori` int(11)
,`nama_kategori` varchar(255)
,`jumlah_barang` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `viewlaporanstokkategori`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `viewlaporanstokkategori` (
`nama_kategori` varchar(255)
,`jumlah_barang` bigint(21)
,`rata_stok` decimal(14,4)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `viewstokrendah`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `viewstokrendah` (
`nama_barang` text
,`stok` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `viewstokrendahrata`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `viewstokrendahrata` (
`nama_barang` text
,`stok` int(11)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `viewbarangkategori`
--
DROP TABLE IF EXISTS `viewbarangkategori`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewbarangkategori`  AS SELECT `barang`.`nama_barang` AS `nama_barang`, `kategori`.`nama_kategori` AS `nama_kategori`, `barang`.`harga_jual` AS `harga_jual` FROM (`barang` join `kategori` on(`barang`.`id_kategori` = `kategori`.`id_kategori`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `viewbarangmahal`
--
DROP TABLE IF EXISTS `viewbarangmahal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewbarangmahal`  AS SELECT `barang`.`nama_barang` AS `nama_barang`, `barang`.`harga_jual` AS `harga_jual` FROM `barang` WHERE `barang`.`harga_jual` > 5000 ;

-- --------------------------------------------------------

--
-- Struktur untuk view `viewlaporankategori`
--
DROP TABLE IF EXISTS `viewlaporankategori`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewlaporankategori`  AS SELECT `k`.`id_kategori` AS `id_kategori`, `k`.`nama_kategori` AS `nama_kategori`, count(`b`.`id_barang`) AS `jumlah_barang` FROM (`kategori` `k` left join `barang` `b` on(`k`.`id_kategori` = `b`.`id_kategori`)) GROUP BY `k`.`id_kategori`, `k`.`nama_kategori` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `viewlaporanstokkategori`
--
DROP TABLE IF EXISTS `viewlaporanstokkategori`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewlaporanstokkategori`  AS SELECT `kategori`.`nama_kategori` AS `nama_kategori`, count(`barang`.`id_barang`) AS `jumlah_barang`, avg(`barang`.`stok`) AS `rata_stok` FROM (`kategori` join `barang` on(`kategori`.`id_kategori` = `barang`.`id_kategori`)) GROUP BY `kategori`.`nama_kategori` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `viewstokrendah`
--
DROP TABLE IF EXISTS `viewstokrendah`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewstokrendah`  AS SELECT `barang`.`nama_barang` AS `nama_barang`, `barang`.`stok` AS `stok` FROM `barang` WHERE `barang`.`stok` < 40 ;

-- --------------------------------------------------------

--
-- Struktur untuk view `viewstokrendahrata`
--
DROP TABLE IF EXISTS `viewstokrendahrata`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewstokrendahrata`  AS SELECT `barang`.`nama_barang` AS `nama_barang`, `barang`.`stok` AS `stok` FROM `barang` WHERE `barang`.`stok` < (select avg(`barang`.`stok`) from `barang`) ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`),
  ADD KEY `fk_barang_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id_login`),
  ADD UNIQUE KEY `user` (`user`),
  ADD KEY `fk_login_pegawai` (`id_pegawai`);

--
-- Indeks untuk tabel `log_barang`
--
ALTER TABLE `log_barang`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `fk_log_barang` (`id_barang`);

--
-- Indeks untuk tabel `nota`
--
ALTER TABLE `nota`
  ADD PRIMARY KEY (`id_nota`),
  ADD KEY `fk_nota_barang` (`id_barang`),
  ADD KEY `fk_nota_pegawai` (`id_pegawai`);

--
-- Indeks untuk tabel `pegawai`
--
ALTER TABLE `pegawai`
  ADD PRIMARY KEY (`id_pegawai`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `NIK` (`NIK`);

--
-- Indeks untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD KEY `fk_penjualan_barang` (`id_barang`),
  ADD KEY `fk_penjualan_pegawai` (`id_pegawai`);

--
-- Indeks untuk tabel `toko`
--
ALTER TABLE `toko`
  ADD PRIMARY KEY (`id_toko`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `login`
--
ALTER TABLE `login`
  MODIFY `id_login` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `log_barang`
--
ALTER TABLE `log_barang`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `nota`
--
ALTER TABLE `nota`
  MODIFY `id_nota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `pegawai`
--
ALTER TABLE `pegawai`
  MODIFY `id_pegawai` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `toko`
--
ALTER TABLE `toko`
  MODIFY `id_toko` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `fk_barang_kategori` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `fk_login_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `log_barang`
--
ALTER TABLE `log_barang`
  ADD CONSTRAINT `fk_log_barang` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `nota`
--
ALTER TABLE `nota`
  ADD CONSTRAINT `fk_nota_barang` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_nota_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `fk_penjualan_barang` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_penjualan_pegawai` FOREIGN KEY (`id_pegawai`) REFERENCES `pegawai` (`id_pegawai`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;