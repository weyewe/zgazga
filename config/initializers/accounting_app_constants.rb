GL_STATUS = {
  :credit => 1, 
  :debit => 2 
}


ACCOUNT_GROUP = {
  :asset => 1,
  :expense => 2, 
  :liability => 3, 
  :revenue => 4, 
  :equity => 5 
  
}



NORMAL_BALANCE = {
  :debit => 1 , 
  :credit => 2 
}

ACCOUNT_CASE = {
  :group => 1,  # group => can't create transaction on group_account
  # group account can have sub_groups and ledger_account 
  :ledger => 2  # ledger_account is where the journal is associated to
} 
 


ACCOUNT_CODE = {
  :aktiva => {
    :code => "1",
    :name => "AKTIVA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
  },
  :aktiva_lancar => {
    :code => "11",
    :name => "AKTIVA LANCAR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1"
  },
  :kas_dan_setara_kas => {
    :code => "1101",
    :name => "KAS DAN SETARA KAS",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
  },
  :kas  => {
    :code => "110101",
    :name => "KAS",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1101"
  },
  :bank  => {
    :code => "110102",
    :name => "BANK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1101"
  },
  :deposito_berjangka_level_1  => {
    :code => "1102",
    :name => "DEPOSITO BERJANGKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
  },
  :deposito_berjangka_level_2  => {
    :code => "110201",
    :name => "DEPOSITO BERJANGKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1102"
  },
  :deposito_berjangka_rupiah  => {
    :code => "11020001",
    :name => "DEPOSITO BERJANGKA RP",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "110201"
  },
  :deposito_berjangka_usd  => {
    :code => "11020002",
    :name => "DEPOSITO BERJANGKA USD",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "110201"
  },
  :piutang_usaha_level_1  => {
    :code => "1103",
    :name => "PIUTANG USAHA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
  },
  :piutang_usaha_level_2  => {
    :code => "110300",
    :name => "PIUTANG USAHA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1103"
    },  
  :piutang_lain_lain_level_1  => {
    :code => "1104",
    :name => "PIUTANG LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :piutang_lain_lain_level_2  => {
    :code => "110401",
    :name => "PIUTANG LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1104"
    },
  :piutang_lainnya  => {
    :code => "11040003",
    :name => "PIUTANG LAINNYA",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110401"
    },
  :piutang_gbch  => {
    :code => "110402",
    :name => "PIUTANG GBCH",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1104"
    },
  :persediaan_barang_level_1  => {
    :code => "1105",
    :name => "PERSEDIAAN BARANG",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :persediaan_barang_level_2  => {
    :code => "110501",
    :name => "PERSEDIAAN BARANG",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1105"
    },
  :persediaan_printing_chemicals  => {
    :code => "11050001",
    :name => "PERSED. PRINTING CHEMICALS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :persediaan_printing_blanket  => {
    :code => "11050002",
    :name => "PERSED. PRINTING BLANKET",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },  
  :persediaan_printing_rollers  => {
    :code => "11050003",
    :name => "PERSED. PRINTING ROLLERS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :persediaan_barang_lainnya  => {
    :code => "11050004",
    :name => "PERSED. BARANG LAINNYA",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :persediaan_bahan_pembantu  => {
    :code => "11050005",
    :name => "PERSED. BAHAN PEMBANTU",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :bahan_baku_chemicals  => {
    :code => "11050101",
    :name => "BAHAN BAKU CHEMICALS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :bahan_baku_blanket  => {
    :code => "11050102",
    :name => "BAHAN BAKU BLANKET",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :bahan_baku_rollers  => {
    :code => "11050103",
    :name => "BAHAN BAKU ROLLERS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :bahan_baku_other  => {
    :code => "11050104",
    :name => "BAHAN BAKU OTHER",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110501"
    },
  :uang_muka_pembelian_level_1  => {
    :code => "1106",
    :name => "UANG MUKA PEMBELIAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :uang_muka_pembelian_level_2 => {
    :code => "110601",
    :name => "UANG MUKA PEMBELIAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1106"
    },
  :uang_muka_pembelian_lokal => {
    :code => "11060001",
    :name => "UANG MUKA PEMBELIAN LOKAL",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110601"
    },
  :uang_muka_pembelian_impor => {
    :code => "11060002",
    :name => "UANG MUKA PEMBELIAN IMPOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110601"
    },
  :uang_muka_lainnya => {
    :code => "11060003",
    :name => "UANG MUKA PEMBELIAN LAINNYA",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110601"
    },
  :pajak_dibayar_di_muka_level_1 => {
    :code => "1107",
    :name => "PAJAK DIBAYAR DI MUKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :pajak_dibayar_di_muka_level_2 => {
    :code => "110701",
    :name => "PAJAK DIBAYAR DI MUKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1107"
    },
  :pph_ps_22 => {
    :code => "11070001",
    :name => "PPH PS 22",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110701"
    },
  :pph_ps_23 => {
    :code => "11070002",
    :name => "PPH PS 23",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110701"
    },
  :pph_ps_25 => {
    :code => "11070003",
    :name => "PPH PS 25",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110701"
    },
  :ppn_masukan => {
    :code => "11070004",
    :name => "PPN MASUKAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110701"
    },
  :pph_ps_24 => {
    :code => "11070005",
    :name => "PPH PS 24",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110701"
    },
  :biaya_dibayar_di_muka_level_1 => {
    :code => "1108",
    :name => "BIAYA DIBAYAR DI MUKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "11"
    },
  :biaya_dibayar_di_muka_level_2 => {
    :code => "110801",
    :name => "BIAYA DIBAYAR DI MUKA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1108"
    },
  :biaya_dibayar_di_muka_asuransi_kendaraan => {
    :code => "11080001",
    :name => "BDD-ASURANSI KENDARAAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110801"
    },
  :biaya_dibayar_di_muka_asuransi_gedung => {
    :code => "11080002",
    :name => "BDD-ASURANSI GEDUNG",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110801"
    },
  :biaya_dibayar_di_muka_asuransi_inventaris_kantor => {
    :code => "11080003",
    :name => "BDD-ASS. INVENTARIS KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110801"
    },
  :biaya_dibayar_di_muka_asuransi_mesin_peralatan => {
    :code => "11080004",
    :name => "BDD-ASS. MESIN PERALATAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110801"
    },
  :biaya_dibayar_di_muka_sewa_gedung_kantor => {
    :code => "11080006",
    :name => "BDD-SEWA GEDUNG/LANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "110801"
    },
  :aktiva_tetap => {
    :code => "14",
    :name => "AKTIVA TETAP",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1"
    }, 
  :tanah_level_1 => {
    :code => "1401",
    :name => "TANAH",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "14"
    }, 
  :tanah_level_2 => {
    :code => "140101",
    :name => "TANAH",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1401"
    },
  :tanah_level_3 => {
    :code => "14010001",
    :name => "TANAH",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "1401"
    }, 
  :bangunan_level_1 => {
    :code => "1402",
    :name => "BANGUNAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "14"
    }, 
  :bangunan_level_2 => {
    :code => "140201",
    :name => "BANGUNAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1402"
    }, 
  :bangunan_level_3 => {
    :code => "14020001",
    :name => "BANGUNAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "140201"
    }, 
  :kendaraan_bermotor_level_1 => {
    :code => "1403",
    :name => "KENDARAAN BERMOTOR(D)",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "14"
    }, 
  :kendaraan_bermotor_level_2 => {
    :code => "140301",
    :name => "KENDARAAN BERMOTOR(D)",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1403"
    }, 
  :kendaraan_bermotor_level_3 => {
    :code => "14030001",
    :name => "KENDARAAN BERMOTOR(D)",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "140301"
    }, 
  :inventaris_kantor_level_1 => {
    :code => "1405",
    :name => "INVENTARIS KANTOR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "14"
    }, 
  :inventaris_kantor_level_2 => {
    :code => "140501",
    :name => "INVETARIS KANTOR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1405"
    },   
  :inventaris_kantor_level_3 => {
    :code => "14050001",
    :name => "INVENTARIS KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "140501"
    },  
  :instalasi_listrik_level_1 => {
    :code => "1407",
    :name => "INSTALASI LISTRIK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "14"
    }, 
  :instalasi_listrik_level_2 => {
    :code => "140701",
    :name => "INSTALASI LISTRIK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1407"
    },   
  :instalasi_listrik_level_3 => {
    :code => "14070001",
    :name => "INSTALASI LISTRIK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "140701"
    },
  :akumulasi_penyusutan_level_1 => {
    :code => "1408",
    :name => "AKUMULASI PENYUSUTAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "14"
    },
  :akumulasi_penyusutan_level_2 => {
    :code => "140801",
    :name => "AKUMULASI PENYUSUTAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "1408"
    },
  :akumulasi_penyusutan_bangunan => {
    :code => "14080001",
    :name => "AKUM. PENY. BANGUNAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "140801"
    },
  :akumulasi_penyusutan_kendaraan_bermotor => {
    :code => "14080002",
    :name => "AKUM. PENY. KEND. BERMOTOR-D",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "140801"
    },
  :akumulasi_penyusutan_inventaris_kantor => {
    :code => "14080004",
    :name => "AKUM. PENY. INVENTARIS KANTOR",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "140801"
    },
  :akumulasi_penyusutan_mesin_peralatan => {
    :code => "14080005",
    :name => "AKUM. PENY. MESIN-PERALATAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "140801"
    },
  :akumulasi_penyusutan_instalasi_listrik => {
    :code => "14080006",
    :name => "AKUM. PENY. INSTALASI LISTRIK",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "140801"
    },
  :akumulasi_penyusutan_aktiva_leasing => {
    :code => "14080007",
    :name => "AKUM. PENY. INSTALASI LISTRIK",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "140801"
    },
  :aktiva_lain_lain => {
    :code => "15",
    :name => "AKTIVA LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1"
    },
  :uang_jaminan_level_1 => {
    :code => "1501",
    :name => "UANG JAMINAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "15"
    },
  :uang_jaminan_level_2 => {
    :code => "150101",
    :name => "UANG JAMINAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "1501"
    },  
  :uang_jaminan_level_3 => {
    :code => "15010001",
    :name => "UANG JAMINAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "150101"
    },  
  :passiva => {
    :code => "2",
    :name => "PASSIVA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => nil
    },  
  :kewajiban_lancar => {
    :code => "21",
    :name => "KEWAJIBAN LANCAR",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2"
    },
  :hutang_bank_level_1 => {
    :code => "2101",
    :name => "HUTANG BANK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },
  :hutang_bank_level_2 => {
    :code => "210101",
    :name => "HUTANG BANK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2102"
    },
  :hutang_bank_level_3 => {
    :code => "21010001",
    :name => "HUTANG BANK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "210201"
    },
  :hutang_leasing => {
    :code => "21010002",
    :name => "HUTANG LEASING",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210201"
    },  
  :hutang_usaha_level_1 => {
    :code => "2102",
    :name => "HUTANG USAHA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },  
  :hutang_usaha_level_2 => {
    :code => "210201",
    :name => "HUTANG USAHA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2102"
    },
  :hutang_pembelian_lokal => {
    :code => "21020001",
    :name => "HUTANG PEMBELIAN LOKAL",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210201"
    },
  :hutang_pembelian_import => {
    :code => "21020002",
    :name => "HUTANG PEMBELIAN IMPORT",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210201"
    },
  :hutang_pembelian_lainnya => {
    :code => "21020003",
    :name => "HUTANG PEMBELIAN LAINNYA",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210201"
    },
  :hutang_lain_lain_level_1 => {
    :code => "2103",
    :name => "HUTANG LAIN-LAIN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },  
  :hutang_lain_lain_level_2 => {
    :code => "210301",
    :name => "HUTANG LAIN-LAIN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2103"
    },
  :hutang_lainnya => {
    :code => "21030002",
    :name => "HUTANG LAINNYA",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210301"
    },
  :hutang_gbch => {
    :code => "210302",
    :name => "HUTANG GBCH",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2103"
    },
  :uang_muka_penjualan_level_1 => {
    :code => "2104",
    :name => "UANG MUKA PENJUALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },  
  :uang_muka_penjualan_level_2 => {
    :code => "210401",
    :name => "UANG MUKA PENJUALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2104"
    },  
  :uang_muka_penjualan_level_3 => {
    :code => "21040001",
    :name => "UANG MUKA PENJUALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210401"
    },  
  :hutang_pajak_level_1 => {
    :code => "2105",
    :name => "HUTANG PAJAK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },
  :hutang_pajak_level_2 => {
    :code => "210501",
    :name => "HUTANG PAJAK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2105"
    },
  :hutang_pph_ps_21 => {
    :code => "21050001",
    :name => "HUTANG PPH PS 21",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    },  
  :hutang_pph_ps_23 => {
    :code => "21050002",
    :name => "HUTANG PPH PS 23",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    }, 
  :hutang_pph_ps_25 => {
    :code => "21050003",
    :name => "HUTANG PPH PS 25",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    }, 
  :hutang_pph_ps_26 => {
    :code => "21050004",
    :name => "HUTANG PPH PS 26",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    }, 
  :hutang_pph_ps_29 => {
    :code => "21050005",
    :name => "HUTANG PPH PS 29",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    }, 
  :hutang_pph_ps_4_2 => {
    :code => "21050006",
    :name => "HUTANG PPH PS 4:2",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    }, 
  :ppn_keluaran => {
    :code => "21050007",
    :name => "PPN KELUARAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210501"
    },
  :biaya_yang_masih_harus_dibayar_level_1 => {
    :code => "2106",
    :name => "BIAYA YMH DIBAYAR",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "21"
    },
  :biaya_yang_masih_harus_dibayar_level_2 => {
    :code => "210601",
    :name => "BIAYA YMH DIBAYAR",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2106"
    },
  :biaya_gaji_yang_masih_harus_dibayar => {
    :code => "21060001",
    :name => "BY. GAJI YMH DIBAYAR",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210601"
    },
  :bunga_bank_yang_masih_harus_dibayar => {
    :code => "21060002",
    :name => "BUNGA BANK YMH DIBAYAR",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210601"
    },  
  :biaya_utilitas_yang_masih_harus_dibayar => {
    :code => "21060003",
    :name => "BY. UTILITAS YMH DIBAYAR",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210601"
    },  
  :biaya_komunikasi_yang_masih_harus_dibayar => {
    :code => "21060004",
    :name => "BY. KOMUNIKASI YMH DIBAYAR",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210601"
    },  
  :biaya_lainnya_yang_masih_harus_dibayar => {
    :code => "21060005",
    :name => "BY. LAINNYA YMH DIBAYAR",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "210601"
    },  
  :kewajiban_jangka_panjang => {
    :code => "22",
    :name => "KEWAJIBAN JANKA PANJANG",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2"
    },      
  :kewajiban_jangka_panjang_hutang_bank_level_1 => {
    :code => "2201",
    :name => "HUTANG BANK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "22"
    },      
  :kewajiban_jangka_panjang_hutang_bank_level_2 => {
    :code => "220101",
    :name => "HUTANG BANK",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "2201"
    },      
  :kewajiban_jangka_panjang_hutang_bank_level_3 => {
    :code => "22010001",
    :name => "HUTANG BANK",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "220101"
    },      
  :modal_level_1 => {
    :code => "3",
    :name => "MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => nil
    },
  :modal_level_2 => {
    :code => "31",
    :name => "MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3"
    },
  :modal_disetor_level_1 => {
    :code => "3101",
    :name => "MODAL DISETOR",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :modal_disetor_level_2 => {
    :code => "310101",
    :name => "MODAL DISETOR",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3101"
    },
  :modal_disetor_level_3 => {
    :code => "31010001",
    :name => "MODAL DISETOR",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "310101"
    },
  :laba_rugi_ditahan_level_1 => {
    :code => "3102",
    :name => "LABA RUGI DITAHAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :laba_rugi_ditahan_level_2 => {
    :code => "310201",
    :name => "LABA RUGI DITAHAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3102"
    },
  :laba_rugi_ditahan_level_3 => {
    :code => "31020001",
    :name => "LABA RUGI DITAHAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310201"
    },
  :laba_rugi_tahun_berjalan_level_1 => {
    :code => "3103",
    :name => "LABA/RUGI TAHUN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :laba_rugi_tahun_berjalan_level_2 => {
    :code => "310301",
    :name => "LABA/RUGI TAHUN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3104"
    },
  :laba_rugi_tahun_berjalan_level_3 => {
    :code => "31030001",
    :name => "LABA/RUGI TAHUN BERJALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310401"
    },
  :laba_rugi_bulan_berjalan_level_1 => {
    :code => "3104",
    :name => "LABA/RUGI BULAN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :laba_rugi_bulan_berjalan_level_2 => {
    :code => "310401",
    :name => "LABA/RUGI BULAN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3104"
    },
  :laba_rugi_bulan_berjalan_level_3 => {
    :code => "31040001",
    :name => "LABA/RUGI BULAN BERJALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310401"
    },
  :dividen_level_1 => {
    :code => "3105",
    :name => "DIVIDEN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :dividen_level_2 => {
    :code => "310501",
    :name => "DIVIDEN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3105"
    },
  :dividen_level_3 => {
    :code => "31050001",
    :name => "DIVIDEN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310501"
    },
  :koreksi_laba_rugi_ditahan_level_1 => {
    :code => "3106",
    :name => "KOREKSI L/R DITAHAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :koreksi_laba_rugi_ditahan_level_2 => {
    :code => "310601",
    :name => "KOREKSI L/R DITAHAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3106"
    },
  :koreksi_laba_rugi_ditahan_level_3 => {
    :code => "31060001",
    :name => "KOREKSI L/R DITAHAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310601"
    },
  :koreksi_laba_rugi_tahun_berjalan_level_1 => {
    :code => "3107",
    :name => "KOREKSI L/R TAHUN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :koreksi_laba_rugi_tahun_berjalan_level_2 => {
    :code => "310701",
    :name => "KOREKSI L/R TAHUN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3107"
    },
  :koreksi_laba_rugi_tahun_berjalan_level_3 => {
    :code => "31070001",
    :name => "KOREKSI L/R TAHUN BERJALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310701"
    },
  :koreksi_laba_rugi_bulan_berjalan_level_1 => {
    :code => "3108",
    :name => "KOREKSI L/R BULAN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :koreksi_laba_rugi_bulan_berjalan_level_2 => {
    :code => "310801",
    :name => "KOREKSI L/R BULAN BERJALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3108"
    },
  :koreksi_laba_rugi_bulan_berjalan_level_3 => {
    :code => "31080001",
    :name => "KOREKSI L/R BULAN BERJALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310801"
    },
  :penyesuaian_modal_level_1 => {
    :code => "3109",
    :name => "PENYESUAIAN MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "31"
    },
  :penyesuaian_modal_level_2 => {
    :code => "310901",
    :name => "PENYESUAIAN MODAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "3109"
    },
  :penyesuaian_modal_level_3 => {
    :code => "31090001",
    :name => "PENYESUAIAN MODAL",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "310901"
    },
  :pendapatan_level_1 => {
    :code => "4",
    :name => "PENDAPATAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => nil
    },
  :pendapatan_level_2 => {
    :code => "41",
    :name => "PENDAPATAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "4"
    },
  :pendapatan_penjualan_level_1 => {
    :code => "4101",
    :name => "PENDAPATAN PENJUALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "41"
    },
  :pendapatan_penjualan_level_2 => {
    :code => "410101",
    :name => "PENDAPATAN PENJUALAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "4101"
    },
  :pendapatan_penjualan_level_3 => {
    :code => "41010001", 
    :name => "PENDAPATAN PENJUALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "410101"
    },
  :potongan_penjualan_level_1 => {
    :code => "4102",
    :name => "POTONGAN PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "41"
    },
  :potongan_penjualan_level_2 => {
    :code => "410201",
    :name => "POTONGAN PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "4102"
    },
  :potongan_penjualan_level_3 => {
    :code => "41020001", 
    :name => "POTONGAN PENJUALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "410201"
    },
  :retur_penjualan_level_1 => {
    :code => "4103",
    :name => "RETUR PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "41"
    },
  :retur_penjualan_level_2 => {
    :code => "410301",
    :name => "RETUR PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "4103"
    },
  :retur_penjualan_level_3 => {
    :code => "41030001", 
    :name => "RETUR PENJUALAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "410301"
    },
  :harga_pokok_level_1 => {
    :code => "5",
    :name => "HARGA POKOK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
    }, 
  :harga_pokok_level_2 => {
    :code => "51",
    :name => "HARGA POKOK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "5"
    }, 
  :harga_pokok_penjualan_level_1 => {
    :code => "5101",
    :name => "HARGA POKOK PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "51"
    },  
  :harga_pokok_penjualan_level_2 => {
    :code => "510101",
    :name => "HARGA POKOK PENJUALAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "5101"
    },  
  :harga_pokok_penjualan_level_3 => {
      :code => "51010001",
    :name => "HARGA POKOK PENJUALAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "510101"
    },
  :potongan_pembelian => {
    :code => "51010002",
    :name => "POTONGAN PEMBELIAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "510101"
    },
  :biaya_overhead_pabrik_level_1 => {
    :code => "5102",
    :name => "BIAYA OVERHEAD PABRIK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "51"
    },
  :biaya_overhead_pabrik_level_2 => {
    :code => "510201",
    :name => "BIAYA OVERHEAD PABRIK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "5102"
    },
  :biaya_overhead_pabrik_level_3 => {
    :code => "51020001",
    :name => "BIAYA OVERHEAD PABRIK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "510201"
    },  
  :beban_usaha => {
    :code => "6",
    :name => "BEBAN USAHA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
    },  
  :beban_pemasaran => {
    :code => "61",
    :name => "BEBAN PEMASARAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6"
    },
  :biaya_iklan_dan_reklame_level_1 => {
    :code => "6101",
    :name => "BIAYA IKLAN DAN REKLAME",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "61"
    },
  :biaya_iklan_dan_reklame_level_2 => {
    :code => "610101",
    :name => "BIAYA IKLAN DAN REKLAME",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6101"
    },
  :biaya_iklan_dan_reklame_level_3 => {
    :code => "61010001",
    :name => "BIAYA IKLAN DAN REKLAME",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "610101"
    },
    
  :biaya_pameran_level_1 => {
    :code => "6102",
    :name => "BIAYA PAMERAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "61"
    },
  :biaya_pameran_level_2 => {
    :code => "610201",
    :name => "BIAYA PAMERAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6102"
    },
  :biaya_pameran_level_3 => {
    :code => "61020001",
    :name => "BIAYA PAMERAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "610201"
    },
      
  :biaya_promosi_level_1 => {
    :code => "6103",
    :name => "BIAYA PROMOSI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "61"
    },
  :biaya_promosi_level_2 => {
    :code => "610301",
    :name => "BIAYA PROMOSI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6103"
    },
  :biaya_promosi_level_3 => {
    :code => "61030001",
    :name => "BIAYA PROMOSI",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "610301"
    },
    
    
  :biaya_perjalanan_dinas_level_1 => {
    :code => "6105",
    :name => "BIAYA PERJALANAN DINAS",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "61"
    },
  :biaya_perjalanan_dinas_level_2 => {
    :code => "610501",
    :name => "BIAYA PERJALANAN DINAS",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6105"
    },
  :biaya_perjalanan_dinas_level_3 => {
    :code => "61050001",
    :name => "BIAYA PERJALANAN DINAS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "610501"
    },
  
    
  :biaya_pengiriman_level_1 => {
    :code => "6106",
    :name => "BIAYA PENGIRIMAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "61"
    },
  :biaya_pengiriman_level_2 => {
    :code => "610601",
    :name => "BIAYA PENGIRIMAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6106"
    },
  :biaya_pengiriman_level_3 => {
    :code => "61060001",
    :name => "BIAYA PENGIRIMAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "610601"
    },
    
    
  :biaya_kemasan_level_1 => {
    :code => "6107",
    :name => "BIAYA KEMASAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "61"
    },
  :biaya_kemasan_level_2 => {
    :code => "610701",
    :name => "BIAYA KEMASAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6107"
    },
  :biaya_kemasan_level_3 => {
    :code => "61070001",
    :name => "BIAYA KEMASAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "610701"
    },
    
  :biaya_administrasi_dan_umum => {
    :code => "62",
    :name => "BIAYA ADMINISTRASI & UMUM",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6"
    },
    
  :biaya_tenaga_kerja_level_1 => {
    :code => "6201",
    :name => "BIAYA TENAGA KERJA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
    
  :biaya_tenaga_kerja_level_2 => {
    :code => "620101",
    :name => "BIAYA TENAGA KERJA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6201"
    },
    
  :biaya_gaji_dan_upah => {
    :code => "62010001",
    :name => "BIAYA GAJI DAN UPAH",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "620101"
    },
    
  :premi_jamsostek => {
    :code => "62010002",
    :name => "PREMI JAMSOSTEK",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "620101"
    },
  
  :biaya_rekruitment => {
    :code => "62010003",
    :name => "BIAYA REKRUITMENT",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "620101"
    },
  
  :biaya_pendidikan_dan_latihan => {
    :code => "62010004",
    :name => "BIAYA PENDIDIKAN DAN LATIHAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "620101"
    },
  
  :biaya_perawatan_kesehatan => {
    :code => "62010005",
    :name => "BIAYA PERAWATAN KESEHATAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "620101"
    },
          
  :biaya_operasional_kantor_level_1 => {
    :code => "6202",
    :name => "BIAYA OPERASIONAL KANTOR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_operasional_kantor_level_2 => {
    :code => "620201",
    :name => "BIAYA OPERASIONAL KANTOR",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6202"
    },
  :biaya_cetakan => {
    :code => "62020001",
    :name => "BIAYA CETAKAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_atk => {
    :code => "62020002",
    :name => "BIAYA ATK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_transport => {
    :code => "62020003",
    :name => "BIAYA TRANSPORT(D)",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_perijinan => {
    :code => "62020005",
    :name => "BIAYA PERIJINAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_materai => {
    :code => "62020006",
    :name => "BIAYA MATERAI",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_fotocopy => {
    :code => "62020007",
    :name => "BIAYA FOTOCOPY",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_kebersihan_dan_keamanan => {
    :code => "62020008",
    :name => "BY. KEBERSIHAN & KEAMANAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_pos_dan_kurir => {
    :code => "62020009",
    :name => "BIAYA POS DAN KURIR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_koran_dan_majalah => {
    :code => "62020010",
    :name => "BIAYA KORAN DAN MAJALAH",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_pajak_kendaraan => {
    :code => "62020011",
    :name => "BIAYA PAJAK DAN KENDARAAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_denda_dan_pajak => {
    :code => "62020012",
    :name => "BIAYA DENDA DAN PAJAK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_keperluan_kantor => {
    :code => "62020013",
    :name => "BIAYA KEPERLUAN KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_pembulatan => {
    :code => "62020014",
    :name => "BIAYA PEMBULATAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620201"
    },
  :biaya_pemeliharaan_perbaikan_level_1 => {
    :code => "6203",
    :name => "BY. PEMELIHARAAN-PERBAIKAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_pemeliharaan_perbaikan_level_2 => {
    :code => "620301",
    :name => "BY. PEMELIHARAAN-PERBAIKAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6203"
    },  
  
  :biaya_pemeliharaan_perbaikan_gedung_kantor => {
    :code => "62030001",
    :name => "BPP-GEDUNG KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620301"
    },  
  :biaya_pemeliharaan_perbaikan_gedung_gudang => {
    :code => "62030002",
    :name => "BPP-GEDUNG GUDANG",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620301"
    },  
  :biaya_pemeliharaan_perbaikan_inventaris_kantor => {
    :code => "62030003",
    :name => "BPP-INVENTARIS KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620301"
    },  
  :biaya_pemeliharaan_perbaikan_kendaraan => {
    :code => "62030004",
    :name => "BPP-KENDARAAN (D)",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620301"
    },  
  :biaya_pemeliharaan_perbaikan_mesin_dan_peralatan => {
    :code => "62030006",
    :name => "BPP-MESIN DAN PERALATAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620301"
    },
    
  :biaya_sewa_level_1 => {
    :code => "6204",
    :name => "BIAYA SEWA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_sewa_level_2 => {
    :code => "620401",
    :name => "BIAYA SEWA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6204"
    },  
  :biaya_sewa_kantor=> {
    :code => "62040001",
    :name => "BIAYA SEWA KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620401"
    },  
  :biaya_sewa_gudang => {
    :code => "62040002",
    :name => "BIAYA SEWA GEDUNG",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620401"
    },  
  
  :biaya_utilitas_komunikasi_level_1 => {
    :code => "6205",
    :name => "BIAYA UTILITAS-KOMUNIKASI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_utilitas_komunikasi_level_2 => {
    :code => "620501",
    :name => "BIAYA UTILITAS-KOMUNIKASI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6205"
    },  
  :biaya_listrik => {
    :code => "62050001",
    :name => "BIAYA LISTRIK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620501"
    },  
  :biaya_pam => {
    :code => "62050002",
    :name => "BIAYA PAM",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620501"
    }, 
    
  :biaya_telepon => {
    :code => "62050003",
    :name => "BIAYA TELEPON",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620501"
    }, 
  :biaya_faksimili => {
    :code => "62050004",
    :name => "BIAYA FAKSIMILI",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620501"
    }, 
  :biaya_hp => {
    :code => "62050005",
    :name => "BIAYA HP",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620501"
    }, 
  :biaya_internet => {
    :code => "62050006",
    :name => "BIAYA INTERNET",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620501"
    }, 
    
  :biaya_jasa_operasional_level_1 => {
    :code => "6206",
    :name => "BIAYA JASA OPERASIONAL",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_jasa_operasional_level_2 => {
    :code => "620601",
    :name => "BIAYA JASA OPERASIONAL",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6206"
    },  
  :biaya_notaris => {
    :code => "62060001",
    :name => "BIAYA NOTARIS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    },  
  :biaya_jasa_angkutan => {
    :code => "62060002",
    :name => "BIAYA JASA ANGKUTAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    }, 
  :biaya_penasehat_hukum => {
    :code => "62060003",
    :name => "BIAYA PENASEHAT HUKUM",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    }, 
  :biaya_konsultan_teknik => {
    :code => "62060004",
    :name => "BIAYA KONSULTAN TEKNIK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    }, 
  :biaya_management_fee => {
    :code => "62060005",
    :name => "BIAYA MANAGEMENT FEE",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    }, 
  :biaya_royalti => {
    :code => "62060007",
    :name => "BIAYA ROYALTI",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    },   
  :biaya_penilaian => {
    :code => "62060008",
    :name => "BIAYA PENILAIAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    },  
  :biaya_seminar_dan_kursus => {
    :code => "62060008",
    :name => "BIAYA SEMINAR DAN KURSUS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620601"
    },  
    
  :biaya_asuransi_level_1 => {
    :code => "6207",
    :name => "BIAYA ASURANSI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_asuransi_level_2 => {
    :code => "620701",
    :name => "BIAYA ASURANSI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6207"
    },  
  :biaya_asuransi_kendaraan => {
    :code => "62070001",
    :name => "BIAYA ASURANSI KENDARAAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620701"
    },  
  :biaya_asuransi_gedung => {
    :code => "62070002",
    :name => "BIAYA ASURANSI GEDUNG",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620701"
    }, 
  :biaya_asuransi_inventaris_kantor => {
    :code => "62070003",
    :name => "BY. ASURANSI INVENTARIS KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620701"
    }, 
  :biaya_asuransi_mesin_peralatan => {
    :code => "62070004",
    :name => "BY. ASS MESIN-PERALATAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620701"
    }, 
    
  :biaya_penyusutan_amortisasi_level_1 => {
    :code => "6208",
    :name => "BY. PENYUSUTAN AMORTISASI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_penyusutan_amortisasi_level_2 => {
    :code => "620801",
    :name => "BY. PENYUSUTAN AMORTISASI",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6208"
    },
  :biaya_penyusutan_bangunan => {
    :code => "62080001",
    :name => "BIAYA PENYUSURAN BANGUNAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620801"
    }, 
  :biaya_penyusutan_kendaraan => {
    :code => "62080002",
    :name => "BIAYA PENYUSUTAN KENDARAAN (D)",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620801"
    },  
  :biaya_penyusutan_inventaris_kantor => {
    :code => "62080004",
    :name => "BIAYA PENYUSUTAN INVENTARIS KANTOR",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620801"
    },  
  :biaya_penyusutan_mesin_peralatan => {
    :code => "62080005",
    :name => "BIAYA PENYUSUTAN MESIN-PERALATAN",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620801"
    },   
    
  :biaya_penyusutan_instalasi_listrik => {
    :code => "62080007",
    :name => "BIAYA PENYUSUTAN INSTALASI LISTRIK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620801"
    }, 
  :biaya_penyusutan_aktiva_leasing => {
    :code => "62080008",
    :name => "BIAYA PENYUSUTAN AKTIVA LEASING",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620801"
    },   
    
  :biaya_keuangan_level_1 => {
    :code => "6209",
    :name => "BIAYA KEUANGAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "62"
    },
  :biaya_keuangan_level_2 => {
    :code => "620901",
    :name => "BIAYA KEUANGAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "6209"
    },
  :biaya_bunga_bank => {
    :code => "62090001",
    :name => "BIAYA BUNGA BANK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620901"
    },
  :biaya_administrasi_bank => {
    :code => "62090002",
    :name => "BIAYA ADMINISTRASI BANK",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620901"
    },  
   :biaya_provisi => {
    :code => "62090003",
    :name => "BIAYA PROVISI",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "620901"
    }, 
    
  :pendapatan_dan_beban_lain_lain => {
    :code => "7",
    :name => "PENDAPATAN DAN BEBAN LAIN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => nil
    },
  :pendapatan_lain_lain => {
    :code => "71",
    :name => "PENDAPATAN LAIN-LAIN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "4"
    },
  :pendapatan_bunga_level_1 => {
    :code => "7101",
    :name => "PENDAPATAN BUNGA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "71"
    },
  :pendapatan_bunga_level_2 => {
    :code => "710101",
    :name => "PENDAPATAN BUNGA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "7101"
    },
   :pendapatan_jasa_giro => {
    :code => "71010001",
    :name => "PENDAPATAN JASA GIRO",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710101"
    },
  :pendapatan_bunga_deposito => {
    :code => "71010002",
    :name => "PENDAPATAN BUNGA DEPOSITO",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710101"
    },
  :pendapatan_lainnya_level_1 => {
    :code => "7102",
    :name => "PENDAPATAN LAINNYA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "71"
    },
  :pendapatan_lainnya_level_2 => {
    :code => "710201",
    :name => "PENDAPATAN LAINNYA",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "7102"
    },
  :pendapatan_selisih_kurs => {
    :code => "71020001",
    :name => "PENDAPATAN SELISIH KURS",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710201"
    },  
   :pendapatan_lainnya => {
    :code => "71020002",
    :name => "PENDAPATAN LAINNYA",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710201"
    },  
    
  :pendapatan_non_operasional_level_1 => {
    :code => "7103",
    :name => "PENDAPATAN NON OPERASIONAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "71"
    },
  :pendapatan_non_operasional_level_2 => {
    :code => "710301",
    :name => "PENDAPATAN NON OPERASIONAL",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "7103"
    },
  :pendapatan_laba_penjualan_aktiva_tetap => {
    :code => "71030001",
    :name => "LABA PENJUALAN AKTIVA TETAP",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710301"
    },  
   :laba_sale_dan_lease_back => {
    :code => "71030002",
    :name => "LABA SALE & LEASE BACK",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "710301"
    },  
  :beban_lain_lain_level_1 => {
    :code => "72",
    :name => "BEBAN LAIN LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "7"
    },
  
  :beban_lain_lain_level_2 => {
    :code => "7201",
    :name => "BEBAN LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "72"
    },   
  :beban_lain_lain_level_3 => {
    :code => "720101",
    :name => "BEBAN LAIN-LAIN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "7201"
    },  
  :beban_lainnya => {
    :code => "72010002",
    :name => "BEBAN LAINNYA",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "720101"
    },  
  :rugi_selisih_kurs => {
    :code => "72010001",
    :name => "RUGI SELISIH KURS",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "720101"
    }, 
  :beban_non_operasional_level_1 => {
    :code => "7202",
    :name => "BEBAN NON OPERASIONAL",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "72"
    },
    
  :beban_non_operasional_level_2 => {
    :code => "720201",
    :name => "BEBAN NON OPERASIONAL",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "7202"
    },
  :laba_penjualan_aktiva_tetap => {
    :code => "72020001",
    :name => "LABA PENJUALAN AKTIVA TETAP",
    :normal_balance => 1,
    :status => 2,
    :parent_code => "720201"
    },  
  
  :biaya_pendapatan_luar_biasa => {
    :code => "8",
    :name => "BIAYA/PEND LUAR BIASA",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
    },
    
  
  :pajak_penghasilan_level_1 => {
    :code => "9",
    :name => "PAJAK PENGHASILAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => nil
    },
  :pajak_penghasilan_level_2 => {
    :code => "91",
    :name => "PAJAK PENGHASILAN",
    :normal_balance => 1,
    :status => 1,
    :parent_code => "9"
    },
  :pajak_penghasilan_level_3 => {
    :code => "9101",
    :name => "PAJAK PENGHASILAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "91"
    },
  :pajak_penghasilan_level_4 => {
    :code => "910101",
    :name => "PAJAK PENGHASILAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "9101"
    },
  :pajak_penghasilan_level_5 => {
    :code => "91010001",
    :name => "PAJAK PENGHASILAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "910101"
    },
  :pph_badan_level_1 => {
    :code => "9102",
    :name => "PPH BADAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "91"
    },
   :pph_badan_level_2 => {
    :code => "910201",
    :name => "PPH BADAN",
    :normal_balance => 2,
    :status => 1,
    :parent_code => "9102"
    },
  :biaya_pajak_tangguhan => {
    :code => "91020001",
    :name => "BIAYA PAJAK TANGGUHAN",
    :normal_balance => 2,
    :status => 2,
    :parent_code => "910201"
    },
  
 
 
 
  
  
  
  
  
  
  }
   
  TRANSACTION_DATA_CODE = {
    :cash_bank_adjustment_journal => 10,
    :cash_bank_mutation_journal => 20, 
    :purchase_receival_journal => 30, 
    :purchase_invoice_journal => 40 ,
    :payment_voucher_journal => 50 ,
    :payment_request_journal => 60, 
    :delivery_order_journal => 70 ,
    :sales_invoice_journal => 80 ,  
    :receipt_voucher_journal => 90, 
    :closing_journal => 100, 
    :blanket_order_detail_journal_finish => 110  ,
    :blending_work_order_journal => 120, 
    :sales_invoice_migration_journal => 130, 
    :purchase_invoice_migration_journal => 140, 
    :bank_administration_journal => 150,
    :memorial_journal => 160,
    :virtual_order_clearance_journal => 170,
    :sales_down_payment_journal => 180,
    :purchase_down_payment_journal => 190,
    :sales_down_payment_allocation_journal  => 200,
    :purchase_down_payment_allocation_journal  => 210,
    :savings_account => 220,
    :membership_savings_account => 230,
    :locked_savings_account => 240,
    :memorial_general => 250,
    :recovery_order_journal => 260,
    :unit_conversion_order_journal => 270,
    :stock_adjustment_journal => 280,
    :customer_stock_adjustment_journal => 280,
    :payable_migration_journal => 666,
    :receivable_migration_journal => 667,
    
  
  
}