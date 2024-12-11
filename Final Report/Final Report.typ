/* Definitions */

#let flex = (..data, maxcolumn: 3, _align: center, gutter: 1em) => {
	set align(_align);
	grid(
		columns: calc.min(maxcolumn, data.pos().len()),
		align: center,
		column-gutter: gutter,
		..data,
	);
}

#let phone = (body, strict: true, brackets: true) => {
	set text(font: "Arial");
	let (l, r) = (() => {
		if brackets == false {
			return ("", "");
		}
		else {
			if strict == true {
				return ("[", "]");
			}
			else {
				return ("/", "/");
			}
		}
	})();
	text[#l#body#r];
}

#let ortho = (body, brackets: false) => {
	set text(font: "Consolas");
	let (l, r) = (() => {
		if brackets == false {
			return ("", "");
		}
		else {
			return ("<", ">");
		}
	})();
	text[#l#body#r];
}

#let realizationTable = (data, letterFilter: none) => {
	if type(data) == str {
		data = csv(data);
	}
	data.at(0).at(0) = "Culture";
	if(letterFilter != none) {
		let index = ();
		index.push(0);
		for i in range(1, data.at(0).len()) {
			let (letters, phones) = data.at(0).at(i).split("_");
			if(letterFilter.contains(letters)) {
				index.push(i);
			}
		}
		for i in range(0, data.len()) {
			let row = data.at(i);
			for j in range(row.len() - 1, -1, step: -1) {
				if index.contains(j) == false {
					let p = row.remove(j);
				}
			}
			data.at(i) = row;
		}
	}
	show table.cell.where(y: 0): it => {
		if it.body.func() == text and it.body.text.contains("_") == false {
			it;
		}
		else {
			let (letters, phones) = it.body.text.split("_");
			table.cell(
				align: horizon + center,
				inset: (x: 0.2em),
			)[#ortho(letters, brackets: false) #phone(phones)];
		}
	};
	table(
		columns: data.at(0).len(),
		align: (left, ..range(1, data.at(0).len()).map(it => center)),

		table.hline(stroke: 1pt),
		..(hrow => {
			for i in range(hrow.len() - 1, 0, step: -1) {
				if hrow.at(i).at(0) != hrow.at(i - 1).at(0) {
					hrow.insert(i, table.vline(stroke: 0.5pt));
				}
			}
			return hrow;
		})(data.at(0)),
		table.hline(stroke: 0.5pt),
		..data.slice(1).flatten(),
		table.hline(stroke: 1pt),
	);
}

/* Preambles */

#set page(paper: "us-letter", margin: 1in)
#set par(justify: true)
#set cite(style: "alphanumeric")
#set text(font: "Times New Roman")
#show text.where(lang: "zh"): set text(font: "KaiTi")
#show link: set text(size: 0.9em, font: "Consolas")
#set quote(quotes: true)
#show quote: set text(style: "italic")
#show table: set block(breakable: true);
#set table(stroke: none);
#show table.cell.where(y: 0): it => {
	set align(center);
	text(it, weight: "bold");
}

/* Title */

#let title = (it) => {
	set align(left);
	par(text(it, size: 17pt, weight: "bold"));
}
#title[Exploring the Cultural Biases in America: On the Phonological Preferences on Pronunciation of Names of Foreign Cultures];

#let member(name: "", localname: "", mail: "") = {
	show link: set text(font: "Consolas");
	set align(center);

	text()[#name (#localname)];
	linebreak();
	link("mailto:" + mail)[<#mail>];
}

#flex(
	member(
		name: "Nian'yi Wang",
		localname: text(lang: "zh")[王念一],
		mail: "wang.nian@northeastern.edu"
	),
	member(
		name: "Xuhong Han",
		localname: text(lang: "zh")[韩徐泓],
		mail: "han.xuho@northeastern.edu"
	),
	member(
		name: "Zesen Liao",
		localname: text(lang: "zh")[廖泽森],
		mail: "liao.zes@northeastern.edu"
	),
)

/* Abstract */

#let abstract = (it, title: [Abstract]) => {
	v(0.5em);

	(body => {
		set align(center);
		show heading: set text(size: 0.9em);
		v(-0.5em);
		heading(level: 1)[#smallcaps(body)];
		v(0.5em);
	})(title);

	par(it);

	v(0.5em);
}
#abstract[
	Accurate name pronunciation is a key element of cultural respect and inclusivity.
	However, in multicultural environments, names from foreign cultures are often mispronounced due to differences between the speaker’s native language and the phonological structure of the name.
	While previous studies have focused on linguistic influences on name pronunciation, the role of visual cultural cues remains underexplored.

	This study investigates whether cultural cues influence the phonological preferences of English speakers when pronouncing foreign names.
	Using a gamified within-subject experimental design, participants were asked to pronounce ambiguous names paired with portraits representing different cultural backgrounds.
	This research reveals implicit biases at the intersection of visual perception and language use, contributing to a deeper understanding of cross-cultural communication.
]

#{
	box(
		width: 100%,
		stroke: 0.5pt,
		inset: 1em,
	)[
		#{
			set text(size: 0.8em);
			set align(center);
			heading(
				level: 1,
				outlined: false,
			)[Notation Convention];
			v(0.5em);
		}

		- This article contains phonetical transcriptions, which are formatted with sans-serif fonts wrapped with brackets.
			Strict transcriptions are wrapped with square brackets, like #phone[\'bɹwækʰɪt]\; loose transcriptions are wrapped wtih slashes, like #phone(strict: false)[\'brækɪt].

		- Orthographies (spellings) are formatted with monospace fonts, usually without wrapping brackets, like #ortho[braket].
			If ambiguity is encountered, angle brackets will be applied, like #ortho(brackets: true)[braket].

		- Asterisks are used to present _p_ values for statistical significance:
			\* \< 0.1, \*\* \< 0.05, \*\*\* \< 0.01.
	]
}

= Introduction

#[
	Accurate pronunciation of names is one of the most important ways to show respect and acceptance in a multicultural environment, such as a university.
	A name is deeply connected to a person’s cultural background and correctly pronouncing it can enhance their sense of belonging and respect.
	However, names from different cultural backgrounds are often mispronounced.
	In environments like the United States, where people come from all over the world, names originating from logographic systems (like Chinese) or other non-English alphabetical systems (like Arabic or Hindi) are frequently mispronounced.
	Even when some names are transliterated to conform to English phonotactic rules, they may still be pronounced incorrectly due to cultural assumptions or stereotypes.

	Most existing research has focused on how linguistic factors, like phonotactics and spelling, influence name pronunciation.
	For example, studies have examined how native phonological rules shape the way people process unfamiliar names.
	However, less attention has been given to the role of visual cues, such as a person's ethnicity, clothing, or perceived cultural background, in shaping assumptions about pronunciation.
	When people see a name paired with a face, they often draw cultural or ethnic inferences based on visual traits, which can affect how they think the name should sound.
	These assumptions may lead to predictable changes in pronunciation, such as shifts in stress or vowel sounds.

	This study explores whether English speakers show specific patterns when pronouncing names from different cultures and what those patterns might be.
	By analyzing how cultural cues in visuals affected pronunciation, the research aims to uncover hidden biases.
	In a game-like experiment, participants see ambiguous names paired with AI-generated portraits from various cultural backgrounds.
	The pairings are randomized to focus on how cultural clues influence pronunciation rather than the names themselves.
	Key features like stress, vowels, and consonants are analyzed to find patterns tied to cultural influence.

	This study not only contributes to the understanding of cross-cultural communication challenges but also highlights the ways in which visual and linguistic biases intersect.
	By uncovering these implicit patterns, the research offers valuable insights into promoting inclusivity and respect in diverse environments, particularly in educational and professional contexts where accurate name pronunciation is critical.
]

= Background

#[
	Digging into past works, this exploration combines knowledge from linguistics social psychology, and phonology to tackle how visuals from culture play a part in the way we pronounce names.
	Key sources give the needed backdrop to grasp the theory and importance behind the study.

	== Cultural and Linguistic Stereotypes

	Maremukova @maremukova2020language explored how cultural stereotypes are linguistically projected in different languages, highlighting how language reflects cultural perceptions and shapes worldviews. This research underscores the role of stereotypes in influencing linguistic behavior, which is central to understanding why visual cultural cues might affect pronunciation patterns. Similarly, Nemer @nemer1987phonological analyzed phonological stereotypes in the Temne language, demonstrating how linguistic biases arise from perceptual habits and social contexts. These works establish that linguistic behavior is not isolated from cultural perceptions but is deeply intertwined with societal norms and stereotypes.

	== Visual and Social Influences on Language

	Barton and Halberstadt @barton2018social introduced the concept of the "social Bouba/Kiki effect," showing how name-face congruence influences social judgments. Their findings suggest that visual characteristics, such as facial shapes, can bias expectations about names, laying the groundwork for investigating whether cultural visual cues similarly bias phonological assumptions. Kristiansen @kristiansen2006towards emphasized the dynamic nature of phonemic categories, arguing that linguistic change is heavily influenced by social cognition and contextual factors. Together, these studies highlight the potential impact of visual cues on linguistic behavior, supporting the hypothesis that cultural appearance could influence name pronunciation.

	== Visual and Social Influences on Language

	Barton and Halberstadt @barton2018social introduced the concept of the "social Bouba/Kiki effect," showing how name-face congruence influences social judgments. Their findings suggest that visual characteristics, such as facial shapes, can bias expectations about names, laying the groundwork for investigating whether cultural visual cues similarly bias phonological assumptions. Kristiansen @kristiansen2006towards emphasized the dynamic nature of phonemic categories, arguing that linguistic change is heavily influenced by social cognition and contextual factors. Together, these studies highlight the potential impact of visual cues on linguistic behavior, supporting the hypothesis that cultural appearance could influence name pronunciation.

	== Phonetic Bias and Pronunciation Challenges

	Tyerman @tyerman2022showing discussed the complexity of name pronunciation and highlighted the challenges faced by individuals with neurodiverse processing, such as dyslexia. This work reveals that pronunciation errors are not always indicative of disrespect but can stem from cognitive limitations. Garrett and Johnson @garrett2011phonetic analyzed phonetic biases in sound change, demonstrating how pronunciation patterns are shaped by both linguistic and cultural factors. These studies provide insight into the mechanisms underlying pronunciation biases and their connection to cultural interaction.

	== Discrimination and Cross-Cultural Communication

	Baills and Prieto @baills2023embodying examined how rhythmic activities aid in learning foreign pronunciation and discussed labor market discrimination against individuals with ethnically distinctive names. Their findings highlight the real-world implications of pronunciation biases, particularly in professional and educational settings. Chow @chow2014chingchong traced the historical use of phonological stereotypes in derogatory slurs, emphasizing how linguistic biases can perpetuate cultural marginalization. These studies illustrate the broader social consequences of mispronunciations and implicit biases, reinforcing the importance of addressing these issues in multicultural environments.

	== Popular and Viral Cultural Phenomena

	Viral videos on platforms like YouTube and TikTok often parody accents or languages, reflecting and reinforcing cultural stereotypes about pronunciation. For instance, the imitation of Mandarin or Russian accents, as noted in viral videos @brianbeepboop2024fakechinese @straightouttarussia2021fakerussian, shows how stereotypical phonetic features become ingrained in popular culture. These phenomena provide anecdotal evidence of how cultural assumptions shape pronunciation, further motivating the need for systematic research.

	Those research taps into a mix of fields that link language use with how people see culture and judge others. It brings together knowledge from speech sounds, culture noggin stuff, and how folks think and interact in groups. The goal here is to span the divide in how we get how sight clues from different cultures have an influence on how names get said. This helps us get a fuller picture of chatting between different cultures.
]

= Method

#[
	This study investigates whether English speakers exhibit culturally specific phonological preferences when pronouncing names from foreign cultures.
	To explore this, we designed a gamified experiment focused on how visual cultural cues influence pronunciation patterns.
	The method comprises data collection, audio analysis, hypothesis generation, and statistical testing, as detailed below.

	== Experimental Design

	The study employs a within-subject experimental design, where participants are exposed to 10 rounds of tasks.
	Each task involves pronouncing a randomly selected name paired with a portrait representing a specific cultural background.
	All portraits are generated using Midjourney, with carefully selected prompts designed to create images that evoke a strong cultural background influence, potentially impacting participants' name pronunciation.
	Randomization of the name and portrait pairings ensures that participants encounter diverse combinations while avoiding repetition, allowing the isolation of phonological effects attributed to cultural cues rather than individual names.

	#figure(
		caption: [The interactive application used in interviews.],
		flex(
			image("./images/app-illus-1.png"),
			image("./images/app-illus-2.png"),
		),
	)

	== Experiment Procedure

	- Setup

		- The application initializes a new session on every page refresh and warns against accidental closure to prevent data loss.

		- Participants interact with fixed rounds of Q&A units, each presenting a unique name-portrait pairing.

	- Task Flow

		- Round Initialization: A random name and portrait are displayed for each round, with shuffling to prevent repeats.
	
		- Recording: Participants pronounce the name while their voice is recorded. Re-recording or skipping a task is optional.

		- Completion: Upon finishing, participants view a completion screen with a thank-you message and the option to export session data as a JSON file.

	- Data Collection Format

		- Metadata includes the pronunciation data, time, location, and interviewer information.

		- Pronunciation data includes the name, cultural context, portrait URL, and the Base64-encoded voice recording.

	== Research Workflow

	+ Data Collection

		- Participants engage with an offline interactive application. Each session begins by randomly pairing a name and portrait from a predefined pool.

		- Participants view the name and portrait, then pronounce the name while their audio is recorded. Recordings are captured using the MediaStream Recording API and encoded in Base64 format.

	+ Audio Analysis:
		The recorded audio files are analyzed to extract phonological features such as stress placement, vowel centralization, and consonant articulation.

	+ Data Visualization:
		The extracted phonological features are visualized through graphs, enabling the identification of patterns and trends in pronunciation preferences.

	+ Hypothesis Generation:
		Based on the visualized data, multiple hypotheses regarding cultural influences on pronunciation are formulated. For instance, specific cultural portraits may elicit consistent shifts in stress placement.

	+ Hypothesis Testing:
		Each hypothesis is tested using statistical methods, such as P-tests or the Kolmogorov-Smirnov test, to determine the significance of observed patterns.

	+ Conclusion:
		The results are analyzed to draw conclusions about the relationship between visual cultural cues and phonological preferences, contributing to the broader understanding of cross-cultural communication.

	== Participant Recruitment

	Participants were recruited from diverse locations in a metropolitan area through convenience sampling.
	Eligibility criteria required participants to be fluent in English and willing to pronounce names as part of the study.
	Each participant provided informed consent before starting the session and was debriefed about the study's purpose and methodology.

	== Gamified Study Summary

	The study incorporates a gamified interface to enhance engagement.
	Participants interact with the application in a "cultural exploration" scenario, where they decode names paired with portraits from various cultures.
	The interactive design encourages active participation while maintaining the rigor of data collection.

	This method provides a robust framework for investigating the intersection of phonological behavior and cultural perception, offering meaningful insights into implicit biases in cross-cultural communication.

]

= Results

#[
	We have done 3 rounds of interviews with random American citizens (N=23); 174 data samples were yielded.
	After inspecting and cleaning, 89 of them are effective; their strict phonological transcription were coded for later analysis.

	By writing and running automated data-processing scripts, we were able to extract data of three main aspects of the phonological features from the transcriptions: accent (i.e. the stressed syllables), realization of consonants and realization of vowels.

	== Accent

	For the accent aspect, we counted the amount of name pronounciations with and without an accent for each culture, and the ratio between the amounts (@table:accent-count).

	#figure(
		caption: [The distribution of accented and unaccented name pronunciations by culture.],
		table(
			columns: 4,
			align: (left, center, center, center),
			table.hline(stroke: 1pt),
			table.header[Culture][Accented Count][Unaccented Count][Accented Ratio],
			table.hline(stroke: 0.5pt),
			[Asia], [6], [16], [27.27%],
			[Middle East], [9], [22], [29.03%],
			[Southern Europe], [6], [8], [42.86%],
			[Central and Eastern Europe], [4], [7], [36.36%],
			table.hline(stroke: 1pt),
		)
	) <table:accent-count>

	We also inspected the position of the accented syllables in those accented pronunciations (@fig:accent-position).
	The position of the accent is defined as the index of the accented syllable (staring from 0) divided by the amount of the syllables in a pronunciation.

	#figure(
		caption: [The distribution of accent positions by culture.],
		image("./images/accent position boxplot.png", height: 20em),
	) <fig:accent-position>

	== Consonant

	For consonant and vowel realizations, we counted every way of every recognizable _graphs_ (letter sequences that work in a whole to represent a single sound) being realized and summarized all the figures into tables, with rows being the perceived cultures, and columns representing pairs of a graph and its realization.

	It is only the contrast of how the same graph is pronounced across different data that we care about.
	In consideration for statistical significance and clarity, we have filtered out the columns that have enough data points with the following criteria:
	- There must be constrasts presented in the data, i.e. a letter sequence must be pronounced in more than one way.
	- There must be at least two data points in the column, so that it is not an occasional noise.

	After filtering, effective contrasts are observed on realization of #ortho[k], #ortho[l] and #ortho[p] (@table:consonant).

	#figure(
		caption: [The distribution of consonant realization.],
		realizationTable("../Interview/analysis/consonant.csv"),
	) <table:consonant>

	== Vowel

	Under the same filtering process, effective contrasts for vowels are observed on realization of #ortho[a], #ortho[e], #ortho[o] and #ortho[u] (@table:vowel).

	#[
		// #pagebreak()
		#set align(center)
		#set par(justify: false)
		#rotate(
			0deg,
			reflow: true,
		)[
			#figure(
				caption: [The distribution of vowel realization.],
				realizationTable("../Interview/analysis/vowel.csv"),
			) <table:vowel>
		]
		// #pagebreak()
	]
]

= Discussion

#[
	Statistical tests were performed on each phonological feature of each culture against the same feature of all other cultures to see if there is any bias appearing.

	== Accent

	Two-tailed t-tests were performed on accent data.
	The alternative hypothesis here is that the tested culture has an outstanding accented ratio or accent position.
	The results are shown in @table:accent-results.

	#figure(
		caption: [_p_-values for accent features.],
		table(
			columns: 3,
			align: (left, center, center),
			table.hline(stroke: 1pt),
			table.header[Culture][accented ratio][accent position],
			table.hline(stroke: 0.5pt),
			[Asia], [0.570], [0.197],
			[Middle Eastern], [0.642], [0.327],
			[Southern Europe], [0.339], [0.199],
			[Central and Eastern Europe], [0.741], [0.335],
			table.hline(stroke: 1pt),
		),
	) <table:accent-results>

	All _p_-values are greater than 0.1.
	We could then conclude that American people do not show phonological preferences on accent when reading foreign names.

	== Consonant

	For consonant realization, we want to know if certain phonemes are prefered/avoided for some cultures.
	To achieve this, for every consonant graph, we scope on only that graph, and run t-test against the union set of all other cultures.
	This way, we could know how "off" that culture's pronunciations are to the "average" pronunciations.
	The results are shown in @table:consontant-results.

	#figure(
		caption: [Z scores for consonant realization frequency.],
		realizationTable((
			("Culture", "k_k", "k_kʰ", "l_l", "l_ɬ", "p_p", "p_pʰ"),
			("Asia", "-0.153", "0.153", "-0.463", "0.463", "-0.943", "0.943"),
			("Middle Eastern", "-0.153", "0.153", "1.234", "-1.234", "1.205", "-1.205"),
			("Southern Europe", "-1.775*", "1.775*", "-1.629", "1.629", "-1.440", "1.440"),
			("Central and Eastern Europe", "1.255", "-1.255", "0.762", "-0.762", "1.217", "-1.217"),
		)),
	) <table:consontant-results>

	There is only one set of data that is statistically significant:
	When pronouncing names of Southeastern European people, Americans tend to aspirate #ortho[k] and implement it as #phone[kʰ] (as in "Kurt") instead of #phone[k] (as in "skirt").

	However, if we focus only on the aspiration of explosive consonants (#ortho[k] and #ortho[p]) and merge the corresponding columns together, we could get the following results (@table:aspiration-results):

	#figure(
		caption: [Distribution and Z scores for explosive aspiration.],
		table(
			columns: 4,
			align: (left, center, center, center),
			table.hline(stroke: 1pt),
			table.header[Culture][Aspirated][Unaspirated][Z score],
			table.hline(stroke: 0.5pt),
			[Asia], [0.500], [0.500], [-0.725],
			[Middle Eastern], [0.625], [0.375], [0.688],
			[Southern Europe], [0.000], [1.000], [-4.715\*\*\*],
			[Central and Eastern Europe], [1.000], [0.000], [3.799\*\*\*],
			table.hline(stroke: 1pt),
		),
	) <table:aspiration-results>

	We could conclude that when facing Southern European faces, Americans would avoid aspirating the explosives in their names; and when facing Central and Eastern European faces, it's the opposite case: Americans would aspirate almost every explosives.

	== Vowel
]

= Limitation and Future Work

#[
	Our research successfully identified patterns indicating that cultural background influences English speakers' pronunciation preferences when encountering names associated with specific cultures.
	However, there are several limitations we must address in future research.

	First, as a qualitative study, our research lacks a sufficient number and diversity of participants.
	While we collected over a large enough number of data points to analyze pronunciation patterns, this sample size is not large enough to generalize our findings to the broader community or target audience.

	Second, due to the lack of tools to automatically segment name pronunciations from speech and analyze the data, all recordings had to be processed and analyzed manually.
	This approach requires an extremely large amount of work and poses significant challenges if we aim to include a larger number of participants and datasets in future research.

	Another limitation stems from the focus of our study: understanding how people’s appearance influences pronunciation by English speakers.
	Since participants were asked to pronounce specific names, some were influenced by the cultural associations of the names themselves.
	This introduces a confounding factor, particularly with a smaller participant pool.
	However, with a larger sample size, this effect could be minimized due to the law of large numbers---as the number of experiments increases, the average results approach the expected value @dekking2006modern.
	Although we cannot entirely eliminate the cultural influence of the names, the impact of this factor will diminish as the participant pool grows, allowing us to focus more accurately on differences in pronunciation patterns.

	In the future, we plan to recruit a larger and more geographically diverse group of native English speakers as participants.
	Additionally, we aim to develop an improved analysis workflow to reduce the workload associated with manually processing large datasets.
]

= Conclusion

#[
	//
]

#bibliography("./bibliography.bib")