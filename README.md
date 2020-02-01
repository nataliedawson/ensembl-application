== Ensembl application

=== The exercise

* Use the latest human data and the Perl API for Ensembl release 98

* Convert coordinates on chromosome (e.g. chromosome 10 from 25000 to 30000) to the same region in GRCh37

* Make the script as generic as possible

* Run script as a command-line program





== Steps

* Ensure perl is up-to-date (brew update perl)

* Load perl modules needed for Ensembl registry

* Create a 

```
# https://www.ensembl.org/info/docs/api/registry.html
# use this to get the name 
shell> mysql -u anonymous -h ensembldb.ensembl.org -P 3306
mysql> SHOW DATABASES LIKE "homo_sapiens_core_%";
+-----------------------------------------+
| Database (homo_sapiens_core_%)          |
+-----------------------------------------+
| homo_sapiens_core_48_36j                |
| homo_sapiens_core_49_36k                |
| homo_sapiens_core_50_36l                |
| homo_sapiens_core_51_36m                |
| homo_sapiens_core_52_36n                |
| homo_sapiens_core_53_36o                |
| homo_sapiens_core_54_36p                |
| homo_sapiens_core_55_37                 |
| homo_sapiens_core_56_37a                |
| homo_sapiens_core_57_37b                |
| homo_sapiens_core_58_37c                |
| homo_sapiens_core_59_37d                |
| homo_sapiens_core_60_37e                |
| homo_sapiens_core_61_37f                |
| homo_sapiens_core_62_37g                |
| homo_sapiens_core_63_37                 |
| homo_sapiens_core_64_37                 |
| homo_sapiens_core_65_37                 |
| homo_sapiens_core_66_37                 |
| homo_sapiens_core_67_37                 |
| homo_sapiens_core_68_37                 |
| homo_sapiens_core_69_37                 |
| homo_sapiens_core_70_37                 |
| homo_sapiens_core_71_37                 |
| homo_sapiens_core_72_37                 |
| homo_sapiens_core_73_37                 |
| homo_sapiens_core_74_37                 |
| homo_sapiens_core_75_37                 |
| homo_sapiens_core_76_38                 |
| homo_sapiens_core_77_38                 |
| homo_sapiens_core_78_38                 |
| homo_sapiens_core_79_38                 |
| homo_sapiens_core_80_38                 |
| homo_sapiens_core_81_38                 |
| homo_sapiens_core_82_38                 |
| homo_sapiens_core_83_38                 |
| homo_sapiens_core_84_38                 |
| homo_sapiens_core_85_38                 |
| homo_sapiens_core_86_38                 |
| homo_sapiens_core_87_38                 |
| homo_sapiens_core_88_38                 |
| homo_sapiens_core_89_38                 |
| homo_sapiens_core_90_38                 |
| homo_sapiens_core_91_38                 |
| homo_sapiens_core_92_38                 |
| homo_sapiens_core_93_38                 |
| homo_sapiens_core_94_38                 |
| homo_sapiens_core_95_38                 |
| homo_sapiens_core_96_38                 |
| homo_sapiens_core_97_38                 |
| homo_sapiens_core_98_38                 |
| homo_sapiens_core_99_38                 |
| homo_sapiens_coreexpressionatlas_60_37e |
| homo_sapiens_coreexpressionatlas_61_37f |
| homo_sapiens_coreexpressionatlas_62_37f |
| homo_sapiens_coreexpressionatlas_63_37  |
| homo_sapiens_coreexpressionatlas_64_37  |
| homo_sapiens_coreexpressionatlas_65_37  |
| homo_sapiens_coreexpressionatlas_66_37  |
| homo_sapiens_coreexpressionatlas_67_37  |
| homo_sapiens_coreexpressionatlas_68_37  |
| homo_sapiens_coreexpressionatlas_69_37  |
| homo_sapiens_coreexpressionatlas_70_37  |
| homo_sapiens_coreexpressionatlas_71_37  |
| homo_sapiens_coreexpressionatlas_72_37  |
| homo_sapiens_coreexpressionatlas_73_37  |
| homo_sapiens_coreexpressionatlas_74_37  |
| homo_sapiens_coreexpressionatlast_65_37 |
| homo_sapiens_coreexpressionest_51_36m   |
| homo_sapiens_coreexpressionest_52_36n   |
| homo_sapiens_coreexpressionest_53_36o   |
| homo_sapiens_coreexpressionest_54_36p   |
| homo_sapiens_coreexpressionest_55_37    |
| homo_sapiens_coreexpressionest_56_37b   |
| homo_sapiens_coreexpressionest_57_37b   |
| homo_sapiens_coreexpressionest_58_37c   |
| homo_sapiens_coreexpressionest_59_37d   |
| homo_sapiens_coreexpressionest_60_37e   |
| homo_sapiens_coreexpressionest_61_37f   |
| homo_sapiens_coreexpressionest_62_37f   |
| homo_sapiens_coreexpressionest_63_37    |
| homo_sapiens_coreexpressionest_64_37    |
| homo_sapiens_coreexpressionest_65_37    |
| homo_sapiens_coreexpressionest_66_37    |
| homo_sapiens_coreexpressionest_67_37    |
| homo_sapiens_coreexpressionest_68_37    |
| homo_sapiens_coreexpressionest_69_37    |
| homo_sapiens_coreexpressionest_70_37    |
| homo_sapiens_coreexpressionest_71_37    |
| homo_sapiens_coreexpressionest_72_37    |
| homo_sapiens_coreexpressionest_73_37    |
| homo_sapiens_coreexpressionest_74_37    |
| homo_sapiens_coreexpressiongnf_51_36m   |
| homo_sapiens_coreexpressiongnf_52_36n   |
| homo_sapiens_coreexpressiongnf_53_36o   |
| homo_sapiens_coreexpressiongnf_54_36p   |
| homo_sapiens_coreexpressiongnf_55_37    |
| homo_sapiens_coreexpressiongnf_56_37b   |
| homo_sapiens_coreexpressiongnf_57_37b   |
| homo_sapiens_coreexpressiongnf_58_37c   |
| homo_sapiens_coreexpressiongnf_59_37d   |
+-----------------------------------------+
101 rows in set (0.08 sec)
```
