# Design Doc

**COMP 381 Group 4**

**Overview**  

Caenorhabditis elegans (C. elegans) is a free-living nematode that is the species of interest in this project. The gene of interest in C. elegans is XOL-1. XOL-1 is a crucial gene that controls sex determination of C. elegans during embryogenesis. Expression of xol-1 differs depending on the ratio of X chromosomes to autosomes. In XO males, xol-1 is expressed at higher levels, and expressed at lower levels in XX hermaphrodites. Although the Xol-1 gene is well known for its role in sex determination, recent work suggests it influences developmental timing by controlling when dosage compensation begins on the X chromosomes and by regulating the expression levels of genes involved in early development. Dosage compensation is a regulatory process that reduces the expression of X-linked genes in hermaphrodites, ensuring that gene expression levels are balanced between the sexes. Previous work shows that XOL-1 influences developmental timing by altering chromatin states through regulators such as the H3K9 methyltransferase MET-2. Studies have shown that when there is a loss of the xol-1 gene, there is accelerated embryonic cell division and earlier activation of dosage compensation of X chromosomes. This indicates that embryos without normal XOL-1 activity progress through developmental stages earlier than normal.

A key concept is the distinction between chronological age, which refers to the time since an organism was born, and biological age, which reflects the physiological condition of the cells and tissues. Biological age is influenced by factors such as diet, exercise, environment, genetics, and stress, and can reflect an age that is younger or older than your chronological age. This distinction matters because biological age offers a more precise indicator of an organism's health. Individuals who have a lower biological age often have a lower disease risk. Many aging clocks estimate biological age using DNA methylation markers, which are epigenetic modifications in which methyl groups are added to DNA molecules and can influence gene expression. DNA methylation patterns change predictably with age, but a problem we face is that DNA methylation is largely absent in C. elegans, which makes methylation-based aging clocks unsuitable for this species(Meyer & Schumacher, 2021). This is an important limitation to overcome because C. elegans is an organism that is widely used in researching genetics, and therefore, developing an alternative method to determine biological aging in this organism can improve our ability to study how genes influence the aging process and enable similar approaches and comparisons with other organisms.

Previous studies attempted to estimate biological age in C. elegans using full-genome oligonucleotide array gene expression profiles combined with age-relevant behavior phenotypes (Golden et al., 2008). These approaches were limited by variability in gene expression measurements and the restricted coverage of array-based technology. More recent work developed the Binaried transcriptomic aging (BiT age) clock, which predicts biological age using gene expression patterns from transcriptomic data. The transcriptome is the complete set of RNA transcripts produced by genes in a cell at a given time, and it reflects which genes are currently active and how strongly they are expressed. Since aging changes gene expression, the transcriptome can reflect the organism's physiological state. BiT age was built from RNA-seq samples across age and learns gene-expression patterns that track with biological age. This model converts gene expression into binary states and sets genes expressed above the sample median to 1 and genes below or at the median to 0. The model aims to reduce noise but retain the information necessary to determine whether a gene is strongly transcribed or not. In this project, we aim to build a Python pipeline that uses C. elegans RNA seq transcriptome data from dataset GSE262626 to map sequencing reads, quantify gene expression, and calculate the biological age of each sample using the BiT age model. Kallisto will first be used to index the reference transcriptome and quantify RNA-seq reads before applying the BiT age model. The predicted biological ages of xol-1 mutants will then be compared to those of samples and different developmental stages (embryo vs. larvae) using statistical tests. Since XOL-1 regulates the transcription of other developmental genes, deleting this gene may alter downstream gene expression patterns in the transcriptome that are used to determine biological age. The goal of this project is to determine whether disruption of xol-1 influences biological aging in C. elegans. This question is interesting because it investigates whether a gene known for sex determination and embryonic development may also influence biological aging, potentially revealing new connections.

Sources:

Golden, T.R., Hubbard, A., Dando, C., Herren, M.A. and Melov, S. (2008), Age-related behaviors have distinct transcriptional profiles in Caenorhabditis elegans. Aging Cell, 7: 850-865. https://doi.org/10.1111/j.1474-9726.2008.00433.x

Meyer, D.H. and Schumacher, B. (2021), BiT age: A transcriptome-based aging clock near the theoretical limit of accuracy. Aging Cell, 20: e13320. [https://doi.org/10.1111/acel.13320](https://doi.org/10.1111/acel.13320)

Article Source: [XOL-1 regulates developmental timing by modulating the H3K9 landscape in ](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1011238)*[C](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1011238)*[. ](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1011238)*[elegans](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1011238)*[ early embryos](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1011238) Jash E, Azhar AA, Mendoza H, Tan ZM, Escher HN, et al. (2024) XOL-1 regulates developmental timing by modulating the H3K9 landscape in *C*. *elegans* early embryos. PLOS Genetics 20(8): e1011238. [https://doi.org/10.1371/journal.pgen.1011238](https://doi.org/10.1371/journal.pgen.1011238)

Context:

This project addresses the biological problem of whether loss of xol-1, a gene known for sex determination and developmental timing in C. elegans, may also alter biological aging by changing downstream gene expression patterns. This is necessary because traditional DNA methylation-based aging clocks are not applicable to C. elegans, so using available transcriptome data with a transcriptome-based model to assess biological age will help us understand whether xol-1 plays an unrecognized role in the aging process.

Goals:

- Use transcriptome-based analysis to predict biological age in C. elegans samples using the BiT age model

- Process RNA-seq data by quantifying gene expression from the GSE262626 dataset

- Compare the predicted biological gene between the xol-1 mutants and the control samples

- Evaluate differences in biological age between developmental stages, such as the embryo and larvae

- Provide a reproducible and well-documented Python pipeline with clear outputs for biological age prediction and statistical analysis.

## **Proposed Solution**

## **1. Big Picture**

The pipeline is designed as a Python-based workflow that can be executed in Visual Studio Code. It transitions from raw sequencing data (FASTQ) to biological age predictions and then verifies the output data via t-tests.

**Programming Languages, Modules, and Databases Needed**

- Python (Modules)

- Pandas

- Os

- Pingouin

- Scipy.stats

- Statsmodels

- Kallisto

- Databases

- RNA seq data from the nucleotide database

### **Core Workflow Phases:**

1. Build a Kallisto index and quantify GSE262626 samples.

2. Convert raw counts to CPM (Counts Per Million) and binarize them.

3. Apply elastic net coefficients to predict biological age.

4. Compare *xol-1* mutants vs. wild-type controls using t-tests.


## **2. Workflow Phases**

### **Phase 1: Read Mapping & Quantification (Kallisto)**

Install Kallisto using the manual.

Use Kallisto?s pseudo-alignment to map reads from **GSE262626**.

- **Input:** **GSE262626,** which contains transcriptome data, specifically RNA-seq data in a FASTQ format.  

- **Step 1:** kallisto index creates a searchable de Bruijn graph.

- **Step 2:** kallisto quant processes each sample, outputting an abundance.tsv file.

- **Output:** CSV file called GSE65765_CPM.csv, which contains a matrix of transcript abundances (TPM/Est_counts).

### **Phase 2: Data Integration in VS Code**

The Kallisto outputs will be aggregated into a single CSV where rows are **WormBaseIDs** and columns are **Samples**.

- **Conversion:** Raw counts must be normalized to CPM.

- **Filtering:** Make sure the WBG prefix is used to match the BiT predictor requirements.

- This can be done using **pandas** and **os** in Python. 

### **Phase 3: The BiT Age Prediction**

Using the data from kallisto and the provided **Biological_age_prediction.py**, do the following:

1. **Binarization:** For each sample, calculate the median gene expression. Genes expressed above the median are assigned **1**, and those below are assigned **0**. This removes noise from varying sequencing depths.

2. **Clock Application:** Multiply the binary matrix by the Elastic Net coefficients from **Predictor_Genes.csv** and add the intercept (103.546).

3. **Correction:** Run calculate_Bio_Age_correction from **biological_age_correction.py** to account for population survival curves and add a correction factor.

### **Phase 4: Statistical Significance (T-Tests)**

Run the following tests:

- *xol-1* Mutants vs. Wild-Type (Control).

- Embryos vs. Larvae (Developmental validation).

- We use Python's pingouin library v.0.3.3. to determine if the p-value < 0.05.

- Tukey test will be computed with Python's Statsmodels library v.0.10.1.

![](/images/Klx_Image_1.png)

## **3. Data files information**

| Table/File | Key Columns | Purpose |
|---|---|---|
| Predictor_Genes.csv | WormBaseID, ElasticNet_Coef | The weights of the aging clock. |
| GSE65765_CPM.csv | target_id, tpm, est_counts | Output from Kallisto. |
| BitAge_v2_coefficients.csv
 | WormBaseID, ElasticNet_Coef | Used to help get a more accurate reading  
 |
| bio_age_example.csv
 | Run (with SRR number), Biological age in hours  | The final data used for the t-test. |


**PROJECT SETUP and DATA COLLECTION (Manel)**

1. Create Repository

2. Set Up project folders to include

1. Project/ (main folder)

2. Data/ (for all the raw data files)

3. Scripts/ (for all the python code)

4. Results/ (for the output files, tables, and plots)

3. Download the Datasets

5. RNA-seq data (GSE262626 dataset) (**EVERYONE**)

6. Reference Transcriptome (*C. elegans* reference file) (this is the what RNA-seq reads will be compared against)

4. Place the files because  Python scripts in the Scripts/ folder will need to know the exact path to the raw data in the Data/ folder. The goal is to organize it so the code can find the files easily.

**RNA-seq PROCESSING WITH KALLISTO (Neel)**: this turns raw data into usable numbers

5. Build the Kallisto index: essentially by doing so we are creating a searchable "index" of the reference transcriptome. This makes the next step incredibly fast. We only have to do this once.

6. **Run Kallisto Quantification:** We will run Kallisto on *each* sample's FastQ file (LOL) meaning we will have to do it **19 times**, once for each of the 19 samples in the GSE262626 dataset

7. The program will:

- Take the raw RNA reads from a sample.

- Compare them against the index we just built.

- Produce an output file for each sample that contains the **gene expression values** (basically, a count of how active each gene is).

1. *SIDE NOTE*: We could build a Python script that should be written with a loop that goes through a list of the 19 sample files and runs the Kallisto command on each one, saving the output to a unique folder for that sample.

**BIOLOGICAL AGE PREDICTION (Manel + Neel):**

7. We will create an Expression Matrix. We will write a script to combine the individual gene expression files from Kallisto into one large table (the matrix). The rows will be genes, and the columns will be your different samples.

8. We will then run the AgingClock Model. The expression matrix becomes the input for the AgingClock in order to work the tool

9. Output file will be produced which will then contain the predicted biological age for each of our samples

**STATISTICAL ANALYSIS AND VISUALIZATION (Farah):**

10. We will create a Metadata File that will be essential for statistical comparison. This table will list each sample ID and its group it belongs to.

11. We will build a python script to load the biological ages and metadata files. We will then use the scipy.stats.ttest_ind function to compare the groups. This will essentially give us the p-value, which will ultimately tell us if the age between the groups that is statistically different

12. Create Visual. Probably a box plot so that we can compare the biological ages between groups.

| Week | Day | Notable Dates | Manel | Neel  | Farah |
|---|---|---|---|---|---|
| Week 1  | March 11 | Groups assigned, begin Design Doc | Create GitHub repo and project directory structure | Review AgingClock GitHub repo and identify required inputs | Research biological background of transcriptomic aging clocks and do overview |
| Week 1  | March 13 | Group work: Design Doc + Presentation prep | Draft workflow diagram and preprocessing pipeline description + slides that go with information | Draft Implementation plan slides  | Draft introduction slides |
| Week 2  | March 18 | Design Document Due + Initial Group Presentation | Present  | Present  | Present  |
| Week 2 | March 20  | Incorporate Feedback from Presentation | Update project plan and workflow diagrams based on feedback. | Refine technical implementation plan based on feedback. | Update introduction and goals based on feedback. |
| Week 3  | March 25 | Group Work | Write the script to automatically download the raw data files. | Write the script that uses kallisto  to measure gene activity from a data file. | Create a spreadsheet that organizes the samples and describes what each one is (for example:, mutant, control). |
| Week 3 | March 27  | DUE 4:00 PM: Repo Check #1 | Add the data download script and project diagram to the GitHub folder. | Add the gene activity script to the GitHub folder for review. | Add the sample description spreadsheet and the main project README file to GitHub. |
| Week 4  | April 1  | Progress Presentation | Finish and test the data download script. Create slides showing a diagram of the project's steps. | Give 5-min presentation. 
Finish and test the gene activity script. Create slides explaining how gene activity is measured. | Give 5-min presentation. Create slides on our overall progress and what's next. |
| Week 4  | April 3  | No class: EASTER BREAK | ? | ? | ? |
| Week 5 | April 8 | Group Work | Combine the 'download' and 'gene measurement' scripts so they run one after the other. | Write the script that uses the AgingClock tool to calculate the biological age from the gene data. | Start writing the script that will perform the statistical tests and create plots. |
| Week 5  | April 10  | DUE 4:00 PM: Repo Check #2 + Progress Presentation | Add the combined script to GitHub. Prepare slides on progress. | Give a 5-min presentation. Add the age calculation script to GitHub. Prepare slides on the age model. | Update the project's README.md file. Prepare slides on the analysis plan. |
| Week 6  | April 15  | Group Work | Connect all the script pieces together into one main program that runs the entire process. | Help Manel test the full program. Make sure the output from one step works as the input for the next. | Run the complete program to get the first real biological age results for all samples. |
| Week 7  | April 17  | DUE 10:00 PM: Rough Draft App Note | Write the "How it Works" section of the final report. | Write the "Methods" section of the report, explaining the tools we used. | Write the "Introduction" and "Results" sections. Create the first plots and assemble the draft report. |
| Week 7 | April 22 | DUE 4:00 PM: Repo Check #3 | Add comments and instructions to the final code. Add the final version to GitHub. | Double-check all the code for errors. Make sure the list of required tools is documented. | Create the final, polished plots for the report. Write the "How to Run" instructions in the README.md  |
| Week 8 | April 24 | Final Presentation | Present the final project design and show how the program works. | Present the key scientific tools used and explain how they work. | Present the project's main findings, the final graphs, and the conclusion. |
| Week 8 | May 1  | DUE 4:00 PM: Final project code & Final Application Note | Submit the final, fully commented code. | Write the short "Abstract" summary for the report and do a final review. | Do the final proofread and edits on the report and submit it. |
