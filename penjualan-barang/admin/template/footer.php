</div>
</div>
<footer class="sticky-footer bg-white">
    <div class="container my-auto">
        <div class="copyright text-center my-auto">
            <span><?php echo date('Y'); ?> - Warung Pintar</span>
        </div>
    </div>
</footer>
</div>
</div>
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>
<script src="sb-admin/js/sb-admin-2.min.js"></script>
<script src="sb-admin/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="sb-admin/vendor/datatables/dataTables.bootstrap4.min.js"></script>
<script type="text/javascript">
    $(function() {
        $("#example1").DataTable();
        $('#example2').DataTable();
    });
</script>
<?php
$sql = "SELECT * FROM barang WHERE stok <= 3";
$row = $config->prepare($sql);
$row->execute();
$q = $row->fetch();
if ($q['stok'] == 3 || $q['stok'] == 2 || $q['stok'] == 1) {
?>
    <script type="text/javascript">
        $(document).ready(function() {
            var unique_id = $.gritter.add({
                title: 'Peringatan !',
                text: 'stok barang ada yang tersisa kurang dari 3 silahkan pesan lagi !',
                image: 'assets/img/seru.png',
                sticky: true,
                time: '',
                class_name: 'my-sticky-class'
            });
            return false;
        });
    </script>
<?php } ?>
<script type="application/javascript">
    $(document).ready(function() {
        setTimeout(function() {
            $(".alert-danger").fadeIn('slow');
        }, 500);
    });
    setTimeout(function() {
        $(".alert-danger").fadeOut('slow');
    }, 5000);
    $(document).ready(function() {
        setTimeout(function() {
            $(".alert-success").fadeIn('slow');
        }, 500);
    });
    setTimeout(function() {
        $(".alert-success").fadeOut('slow');
    }, 5000);
    $(document).ready(function() {
        setTimeout(function() {
            $(".alert-warning").fadeIn('slow');
        }, 500);
    });
    setTimeout(function() {
        $(".alert-success").fadeOut('slow');
    }, 5000);
</script>
<script>
    $(".modal-create").hide();
    $(".bg-shadow").hide();
    $(".bg-shadow").hide();

    function clickModals() {
        $(".bg-shadow").fadeIn();
        $(".modal-create").fadeIn();
    }

    function cancelModals() {
        $('.modal-view').fadeIn();
        $(".modal-create").hide();
        $(".bg-shadow").hide();
    }
</script>
</body>

</html>