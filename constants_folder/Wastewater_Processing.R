



#### Interop command
library(processx)
#run(command="summary",c("/data_raw/ > /data_output/summary.txt"), wd="/")
#https://github.com/r-lib/processx/issues/254
p <- processx::process$new("summary", c("/data_raw/"), stdout = "/data_output/summary.txt",  wd="/") 
p$wait()
#print(p$get_exit_status())
#if (p$get_exit_status() !=0)
#{
#system("summary /data_raw/ > /data_output/summary.txt",wait=TRUE)



#### R script

library(dplyr)
library(xml2)
Run_Info <- read_xml("/data_raw/RunInfo.xml") 
Run_Parameters <- read_xml("/data_raw/RunParameters.xml") %>% as_list()
Run_Info2 <- read_xml("/data_raw/RunInfo.xml") %>% as_list()

run_name <- xml_attrs(xml_child(Run_Info, 1))[1]
Sample_Sheet_all <- read.csv("/data_raw/SampleSheet.csv",header=FALSE)
rows_to_skip <- grep('\\[Data\\]', Sample_Sheet_all$V1)
Sample_Sheet <- read.csv("/data_raw/SampleSheet.csv",header=TRUE,skip=rows_to_skip)


#Table1 <- read.delim("/data_output/summary.txt", skip=2,sep=",",header=TRUE,nrows=6,check.names = FALSE)
Table_summary_R1 <- read.delim("/data_output/summary.txt",skip=12,sep=",",header=TRUE,nrows=12)
Table_summary_R1_1 <- Table_summary_R1[which(Table_summary_R1$Surface=="-              "),]
Sum_R1_Reads <- sum(Table_summary_R1_1$Reads)
Sum_R1_PFReads <- sum(Table_summary_R1_1$Reads.PF)

library(readxl)
Constants <- read_excel("/constants_folder/constants.xlsx")
Constants2 <- as.data.frame(Constants)
ARTIC_Constants2 <- as.character(Constants2$OGSR)
names(ARTIC_Constants2) <- as.character(Constants2[,1])

Rna_protocol1 <- as.character(unlist(Run_Parameters$RunParameters$Setup))
Names_rna_protocol1 <- as.character(names(Run_Parameters$RunParameters$Setup))
Rna_protocol2 <- paste(Names_rna_protocol1,Rna_protocol1,sep=": ")
Rna_protocol3 <- paste(Rna_protocol2, collapse=', ' )

Sample_Table <- data.frame(
  ### RNA Extraction
  sample_id=as.character(Sample_Sheet$Sample_ID),
  
  ### RNA Quantification
  rnaquant_yn = as.character(ARTIC_Constants2["rnaquant_yn"]),
  rnaquant_assay_kit = as.character(ARTIC_Constants2["rnaquant_assay_kit"]),
  rnaquant_date_of_quant = as.character(ARTIC_Constants2["rnaquant_date_of_quant"]),
  rnaquant_sample_ul = as.character(ARTIC_Constants2["rnaquant_sample_ul"]),
  rnaquant_dilution_concentration = as.character(ARTIC_Constants2["rnaquant_dilution_concentration"]),
  rnaquant_concentration = as.character(ARTIC_Constants2["rnaquant_concentration"]),
  
  ### RNA Library Prep
  rna_libprep_user = as.character(Sample_Sheet$rna_libprep_user),
  rna_libprep_industry = as.character(ARTIC_Constants2["rna_libprep_industry"]),
  rna_libprep_date_of_prep = as.character(Sample_Sheet$rna_libprep_date_of_prep),
  rna_libprep_rRNA_depletion = as.character(ARTIC_Constants2["rna_libprep_rRNA-depletion"]),
  rna_libprep_rRNA_depletion_kit = as.character(ARTIC_Constants2["rna_libprep_rRNA-depletion_kit"]),
  rna_libprep_kit = as.character(ARTIC_Constants2["rna_libprep_kit"]),
  rna_libprep_protocol_version = as.character(ARTIC_Constants2["rna_libprep_protocol_version"]),
  rna_libprep_primer_version = as.character(Sample_Sheet$rna_libprep_primer_version),
  rna_libprep_index = Sample_Sheet$index, ###TODO Update Ben's Sample Sheet
  rna_libprep_index2 = Sample_Sheet$index2, ###TODO Update Ben's Sample Sheet
  rna_libprep_plate_label = NA,
  rna_libprep_position_row = NA,
  rna_libprep_position_column = NA,
  rna_libprep_input_volume = as.character(ARTIC_Constants2["rna_libprep_input_volume"]),
  rna_libprep_elution_volume = as.character(ARTIC_Constants2["rna_libprep_elution_volume"]),
  ## RNA-seq Assay
  rna_seq_runid = as.character(run_name),
  rna_seq_industry = as.character(ARTIC_Constants2["rna_seq_industry"]),
  rna_seq_machine_model = as.character(Run_Parameters$RunParameters$InstrumentID),
  rna_seq_machine_serial_number = as.character(Run_Parameters$RunParameters$RunParametersVersion), #there is a discrepency here with the definitions google sheet
  
  ## RNA-seq Experimental
  #rna_seq_date = Run_Parameters$RunParameters$RunStartDate,
  rna_seq_date = as.character(Run_Info2[["RunInfo"]][["Run"]][["Date"]]) ,
  rna_seq_user = as.character(Run_Parameters$RunParameters$BaseSpaceUserName),
  rna_seq_protocol = Rna_protocol3,
  rna_seq_depth = NA,
  rna_seq_flowcell = as.character(Run_Info2[["RunInfo"]][["Run"]][["Flowcell"]][[1]]),
  rna_seq_lane = NA,
  
  ## RNA-seq Data
  rna_seq_raw_file_name = NA,
  rna_seq_yield_mbases = Sum_R1_Reads,
  rna_seq_raw_reads = Sum_R1_Reads,
  rna_seq_pf_reads = Sum_R1_PFReads,
  rna_seq_notes = NA
)

write.csv(Sample_Table,row.names=FALSE,file = "/data_output/final_output.csv")
#}
