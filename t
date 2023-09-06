LOSETUP(8)                                                                                  System Administration                                                                                  LOSETUP(8)

NNAAMMEE
       losetup - set up and control loop devices

SSYYNNOOPPSSIISS
       Get info:

       lloosseettuupp [_l_o_o_p_d_e_v]

       lloosseettuupp --ll [--aa]

       lloosseettuupp --jj _f_i_l_e [--oo _o_f_f_s_e_t]

       Detach a loop device:

       lloosseettuupp --dd _l_o_o_p_d_e_v ...

       Detach all associated loop devices:

       lloosseettuupp --DD

       Set up a loop device:

       lloosseettuupp [--oo _o_f_f_s_e_t] [----ssiizzeelliimmiitt _s_i_z_e] [----sseeccttoorr--ssiizzee _s_i_z_e] [--PPrr] [----sshhooww] --ff _l_o_o_p_d_e_v _f_i_l_e

       Resize a loop device:

       lloosseettuupp --cc _l_o_o_p_d_e_v

DDEESSCCRRIIPPTTIIOONN
       lloosseettuupp is used to associate loop devices with regular files or block devices, to detach loop devices, and to query the status of a loop device. If only the _l_o_o_p_d_e_v argument is given, the status of
       the corresponding loop device is shown. If no option is given, all loop devices are shown.

       Note that the old output format (i.e., lloosseettuupp --aa) with comma-delimited strings is deprecated in favour of the ----lliisstt output format.

       It’s possible to create more independent loop devices for the same backing file. TThhiiss sseettuupp mmaayy bbee ddaannggeerroouuss,, ccaann ccaauussee ddaattaa lloossss,, ccoorrrruuppttiioonn aanndd oovveerrwwrriitteess.. Use ----nnoooovveerrllaapp with ----ffiinndd during setup
       to avoid this problem.

       The loop device setup is not an atomic operation when used with ----ffiinndd, and lloosseettuupp does not protect this operation by any lock. The number of attempts is internally restricted to a maximum of 16.
       It is recommended to use for example flock1 to avoid a collision in heavily parallel use cases.

OOPPTTIIOONNSS
       The _s_i_z_e and _o_f_f_s_e_t arguments may be followed by the multiplicative suffixes KiB (=1024), MiB (=1024*1024), and so on for GiB, TiB, PiB, EiB, ZiB and YiB (the "iB" is optional, e.g., "K" has the
       same meaning as "KiB") or the suffixes KB (=1000), MB (=1000*1000), and so on for GB, TB, PB, EB, ZB and YB.

       --aa, ----aallll
           Show the status of all loop devices. Note that not all information is accessible for non-root users. See also ----lliisstt. The old output format (as printed without ----lliisstt)) is deprecated.

       --dd, ----ddeettaacchh _l_o_o_p_d_e_v...
           Detach the file or device associated with the specified loop device(s). Note that since Linux v3.7 kernel uses "lazy device destruction". The detach operation does not return EEBBUUSSYY error anymore
           if device is actively used by system, but it is marked by autoclear flag and destroyed later.

       --DD, ----ddeettaacchh--aallll
           Detach all associated loop devices.

       --ff, ----ffiinndd [_f_i_l_e]
           Find the first unused loop device. If a _f_i_l_e argument is present, use the found device as loop device. Otherwise, just print its name.

       ----sshhooww
           Display the name of the assigned loop device if the --ff option and a _f_i_l_e argument are present.

       --LL, ----nnoooovveerrllaapp
           Check for conflicts between loop devices to avoid situation when the same backing file is shared between more loop devices. If the file is already used by another device then re-use the device
           rather than a new one. The option makes sense only with ----ffiinndd.

       --jj, ----aassssoocciiaatteedd _f_i_l_e [--oo _o_f_f_s_e_t]
           Show the status of all loop devices associated with the given _f_i_l_e.

       --oo, ----ooffffsseett _o_f_f_s_e_t
           The data start is moved _o_f_f_s_e_t bytes into the specified file or device. The _o_f_f_s_e_t may be followed by the multiplicative suffixes; see above.

       ----ssiizzeelliimmiitt _s_i_z_e
           The data end is set to no more than _s_i_z_e bytes after the data start. The _s_i_z_e may be followed by the multiplicative suffixes; see above.

       --bb, ----sseeccttoorr--ssiizzee _s_i_z_e
           Set the logical sector size of the loop device in bytes (since Linux 4.14). The option may be used when create a new loop device as well as stand-alone command to modify sector size of the
           already existing loop device.

       --cc, ----sseett--ccaappaacciittyy _l_o_o_p_d_e_v
           Force the loop driver to reread the size of the file associated with the specified loop device.

       --PP, ----ppaarrttssccaann
           Force the kernel to scan the partition table on a newly created loop device. Note that the partition table parsing depends on sector sizes. The default is sector size is 512 bytes, otherwise you
           need to use the option ----sseeccttoorr--ssiizzee together with ----ppaarrttssccaann.

       --rr, ----rreeaadd--oonnllyy
           Set up a read-only loop device.

       ----ddiirreecctt--iioo[==oonn|ooffff]
           Enable or disable direct I/O for the backing file. The optional argument can be either oonn or ooffff. If the argument is omitted, it defaults to ooffff.

       --vv, ----vveerrbboossee
           Verbose mode.

       --ll, ----lliisstt
           If a loop device or the --aa option is specified, print the default columns for either the specified loop device or all loop devices; the default is to print info about all devices. See also
           ----oouuttppuutt, ----nnoohheeaaddiinnggss, ----rraaww, and ----jjssoonn.

       --OO, ----oouuttppuutt _c_o_l_u_m_n[,_c_o_l_u_m_n]...
           Specify the columns that are to be printed for the ----lliisstt output. Use ----hheellpp to get a list of all supported columns.

       ----oouuttppuutt--aallll
           Output all available columns.

       --nn, ----nnoohheeaaddiinnggss
           Don’t print headings for ----lliisstt output format.

       ----rraaww
           Use the raw ----lliisstt output format.

       --JJ, ----jjssoonn
           Use JSON format for ----lliisstt output.

       --VV, ----vveerrssiioonn
           Display version information and exit.

       --hh, ----hheellpp
           Display help text and exit.

EENNCCRRYYPPTTIIOONN
       CCrryyppttoolloooopp iiss nnoo lloonnggeerr ssuuppppoorrtteedd iinn ffaavvoorr ooff ddmm--ccrryypptt.. For more details see ccrryyppttsseettuupp(8).

EEXXIITT SSTTAATTUUSS
       lloosseettuupp returns 0 on success, nonzero on failure. When lloosseettuupp displays the status of a loop device, it returns 1 if the device is not configured and 2 if an error occurred which prevented
       determining the status of the device.

NNOOTTEESS
       Since version 2.37 lloosseettuupp uses LLOOOOPP__CCOONNFFIIGGUURREE ioctl to setup a new loop device by one ioctl call. The old versions use LLOOOOPP__SSEETT__FFDD and LLOOOOPP__SSEETT__SSTTAATTUUSS6644 ioctls to do the same.

EENNVVIIRROONNMMEENNTT
       LOOPDEV_DEBUG=all
           enables debug output.

FFIILLEESS
       _/_d_e_v_/_l_o_o_p_[_0_._._N_]
           loop block devices

       _/_d_e_v_/_l_o_o_p_-_c_o_n_t_r_o_l
           loop control device

EEXXAAMMPPLLEE
       The following commands can be used as an example of using the loop device.

           # dd if=/dev/zero of=~/file.img bs=1024k count=10
           # losetup --find --show ~/file.img
           /dev/loop0
           # mkfs -t ext2 /dev/loop0
           # mount /dev/loop0 /mnt
           ...
           # umount /dev/loop0
           # losetup --detach /dev/loop0

AAUUTTHHOORRSS
       Karel Zak <kzak@redhat.com>, based on the original version from Theodore Ts’o <tytso@athena.mit.edu>.

RREEPPOORRTTIINNGG BBUUGGSS
       For bug reports, use the issue tracker at https://github.com/karelzak/util-linux/issues.

AAVVAAIILLAABBIILLIITTYY
       The lloosseettuupp command is part of the util-linux package which can be downloaded from Linux Kernel Archive <https://www.kernel.org/pub/linux/utils/util-linux/>.

util-linux 2.37.2                                                                                 2021-06-02                                                                                       LOSETUP(8)
