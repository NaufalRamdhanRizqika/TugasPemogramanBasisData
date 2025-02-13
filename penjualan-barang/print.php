<?php
@ob_start();
session_start();

if (!empty($_SESSION['admin'])) {
} else {
	echo '<script>window.location="login.php";</script>';
	exit;
}

require 'config.php';
include $view;
$lihat = new view($config);
$toko = $lihat->toko();
$hsl = $lihat->penjualan();
?>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Print Receipt</title>
	<link rel="stylesheet" href="assets/css/bootstrap.css">
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
			color: #333;
		}

		.container {
			margin-top: 20px;
			margin-bottom: 20px;
		}

		.receipt {
			background-color: #fff;
			border-radius: 10px;
			box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
			padding: 20px;
		}

		.receipt-header {
			text-align: center;
			margin-bottom: 20px;
		}

		.receipt-header h2 {
			font-size: 24px;
			font-weight: 500;
			margin-bottom: 5px;
		}

		.receipt-header p {
			font-size: 14px;
			color: #666;
		}

		.table {
			width: 100%;
			margin-bottom: 20px;
		}

		.table th,
		.table td {
			padding: 12px;
			text-align: center;
		}

		.table th {
			background-color: #f8f9fa;
			font-weight: 500;
		}

		.table tbody tr:hover {
			background-color: #f1f1f1;
		}

		.total-section {
			text-align: right;
			margin-bottom: 20px;
		}

		.total-section p {
			font-size: 16px;
			margin: 5px 0;
		}

		.thank-you {
			text-align: center;
			font-size: 18px;
			font-weight: 500;
			margin-top: 20px;
		}
	</style>
</head>

<body>
	<script>
		window.print();
	</script>
	<div class="container">
		<div class="row">
			<div class="col-sm-4"></div>
			<div class="col-sm-4">
				<div class="receipt">
					<div class="receipt-header">
						<h2><?php echo $toko['nama_toko']; ?></h2>
						<p><?php echo $toko['alamat_toko']; ?></p>
						<p>Tanggal : <?php echo date("j F Y, G:i"); ?></p>
						<p>Kasir : <?php echo htmlentities($_GET['nm_pegawai']); ?></p>
					</div>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>No.</th>
								<th>Barang</th>
								<th>Jumlah</th>
								<th>Total</th>
							</tr>
						</thead>
						<tbody>
							<?php $no = 1;
							foreach ($hsl as $isi) { ?>
								<tr>
									<td><?php echo $no; ?></td>
									<td><?php echo $isi['nama_barang']; ?></td>
									<td><?php echo $isi['jumlah']; ?></td>
									<td><?php echo $isi['total']; ?></td>
								</tr>
							<?php $no++;
							} ?>
						</tbody>
					</table>
					<div class="total-section">
						<?php $hasil = $lihat->jumlah(); ?>
						<p>Total : Rp<?php echo number_format($hasil['bayar'], 0, '', '.'); ?></p>
						<p>Bayar : Rp<?php echo number_format(htmlentities($_GET['bayar']), 0, '', '.'); ?></p>
						<p>Kembali : Rp<?php echo number_format(htmlentities($_GET['kembali']), 0, '', '.'); ?></p>
					</div>
					<div class="thank-you">
						<p>Terima Kasih Telah Berbelanja di Warung Pintar!</p>
					</div>
				</div>
			</div>
			<div class="col-sm-4"></div>
		</div>
	</div>
</body>

</html>