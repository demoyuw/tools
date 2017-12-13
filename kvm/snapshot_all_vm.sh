LOG_DIR=/home/yuwei/log
echo "start snapshot" >> ${LOG_DIR}/snapshot_all_vm.log
date >> ${LOG_DIR}/snapshot_all_vm.log
virsh snapshot-create isc23CTL1 >> ${LOG_DIR}/snapshot_all_vm.log
date >> ${LOG_DIR}/snapshot_all_vm.log
virsh snapshot-create isc23COM1 >> ${LOG_DIR}/snapshot_all_vm.log
date >> ${LOG_DIR}/snapshot_all_vm.log
virsh snapshot-create isc23COM2 >> ${LOG_DIR}/snapshot_all_vm.log
date >> ${LOG_DIR}/snapshot_all_vm.log
virsh snapshot-create isc2networkCTL >> ${LOG_DIR}/snapshot_all_vm.log
date >> ${LOG_DIR}/snapshot_all_vm.log
virsh snapshot-create isc2networkCOM2 >> ${LOG_DIR}/snapshot_all_vm.log
date >> ${LOG_DIR}/snapshot_all_vm.log
virsh snapshot-create isc2networkCOM1 >> ${LOG_DIR}/snapshot_all_vm.log
echo "finish snapshot" >> ${LOG_DIR}/snapshot_all_vm.log
