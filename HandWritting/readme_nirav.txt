	H I D D E N   M A R K O V   M O D E L
		 for automatic speech recognition

7/30/95

  This code implements in C++ a basic left-right hidden Markov model
and corresponding Baum-Welch (ML) training algorithm.  It is meant as
an example of the HMM algorithms described by L.Rabiner (1) and
others.  Serious students are directed to the sources listed below for
a theoretical description of the algorithm.  KF Lee (2) offers an
especially good tutorial of how to build a speech recognition system
using hidden Markov models.  

  Jim and I built this code in order to learn how HMM systems work and
we are now offering it to the net so that others can learn how to use
HMMs for speech recognition.  Keep in mind that efficiency was not our
primary concern when we built this code, but ease of understanding
was.  I expect people to use this code in two different ways.  People
who wish to build an experimental speech recognition system can use
the included "train_hmm" and "test_hmm" programs as black box
components.  The code can also be used in conjunction with written
tutorials on HMMs to understand how they work.

			HOW TO COMPILE IT:

  We built this code on a Linux system (8meg RAM) and it has been
tested under SunOS as well; it should run on any system with Gnu C++
and has been tested to be ANSI compliant.

  To compile and test the program,

	1) extract the code: 

		tar -xf hmm.tar

	2) compile the programs:

		 make -B

	3) create test sequences: 

		./generate_seq test.hmm 20 50

	4) train using existing model: 

		./train_hmm test.hmm.seq test.hmm .01
		
		./test_hmm testseq.hmm.seq test.hmm.seq.hmm




	5) train using random parameters: 

		./train_hmm test.hmm.seq 1234 3 3 .01

./train_hmm 1.txt 143 3 32 .01
./train_hmm o.txt 143 2 32 .01
./train_hmm z.txt 143 3 32 .01

		testing

./test_hmm test.txt 1.txt.hmm 
./test_hmm test.txt o.txt.hmm 
./test_hmm test.txt z.txt.hmm 



  After steps 4 and 5 you can compare the file test.hmm.seq.hmm with
test.hmm to confirm that the program is working.
	
			FILE FORMATS:

  There are two types of files used by these programs.  The first is
the hmm model file which has the following header:

	states: <number of states>
	symbols: <number of symbols> 

A series of ordered blocks follow the header, each of which is two
lines long.  Each block corresponds to a state in the model.  The
first line of each block gives the probability of the model recurring
followed by the probability of generating each of the possible output
symbols when it recurs.  The second line gives the probability of the
model transitioning to the next state followed by the probability of
generating each of the possible output symbols when it transitions.
The file "test.hmm" gives an example of this format for a three state
model with three possible output symbols.

  The second kind of file is a list of symbol sequences to train or
test the model on.  Symbol sequences are space separated integers (0 1
2...) terminated by a newline ("\n").  Sequences may either be all of
the same length, or of different lengths.  The algorithm detects for
each case and processes each slightly differently.  Use the output of
step 3 above for an example of a sequence file.  A file containing
sequences which are all of the same length should train slightly
faster.

			ASR IN A NUTSHELL:

  A complete automatic speech recognition system is likely to include
programs that perform the following tasks:


	1) convert audio/wave files to sequences of multi-dimensional
	   feature vectors. (eg. DFT, PLP, etc)

	2) quantize feature vectors into sequences of symbols (eg. VQ)

	3) train a model for each recognition object (ie. word,
	   phoneme) from the sequences of symbols. (eg. HMM)

	4?) constrain models using grammar information.

  Most of the above components are readily available as freeware and
building a system from them should not be too difficult.  Making it
work well, however, could be a major undertaking; the devil is in the
details.
	
			FUTURE:

  I would like to eventually put together all of the necessary
components for a complete speech recognition test bench.  I envision
something that could be combined with a standard speech database such
as the TIMIT data set.  Such a test bench would allow researchers to
swap in and evaluate their own methods at various stages in the
system.  Reported results could be compared against the performance of
a standard non-optimized system which would be publicly available.
This way two methods could be compared while controlling for different
data sets and pre/post processing.

  Unfortunately, speech recognition is mostly a side line to Jim's
graduate work in neural networks and I currently have a job that has
taken me away from the field of speech recognition.  If someone uses
this code in a complete system, we would appreciate hearing about it.