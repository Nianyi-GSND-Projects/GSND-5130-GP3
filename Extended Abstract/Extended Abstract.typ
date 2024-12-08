// Preambles

#set page(paper: "us-letter", margin: 1in)
#set par(justify: true)
#set cite(style: "alphanumeric")
#set text(font: "Times New Roman")
#show text.where(lang: "zh"): set text(font: "KaiTi")
#show link: set text(size: 0.9em, font: "Consolas")
#set quote(quotes: true)
#show quote: set text(style: "italic")
// #show heading.where(level: 1): set text(costs: (widow: 1000%))

#let phone = (body, strict: true) => {
	set text(font: "Consolas");
	if(strict) {
		text[\[#body\]];
	}
	else {
		text[/#body/];
	}
}
#let ortho = (body) => {
	set text(font: "Consolas");
	text[\<#body\>];
}

// Title

#((title) => {
	set align(left);
	par(text(title, size: 20pt, weight: "bold"));
})[On the Phonological Shifts of American English Users Towards Foreign Names];

#{
	v(-0.5em);
	let member(name: "", localname: "", mail: "") = {
		show link: set text(font: "Consolas", size: 9pt);
		set align(center);

		text()[#name (#localname)];
		linebreak();
		link("mailto:" + mail)[<#mail>];
	};
	table(
		columns: (1fr, 1fr, 1fr),
		stroke: none,

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
	);
}

= Extended Abstract

Correctly pronouncing names is a fundamental aspect of respect and inclusivity, yet many individuals with diverse names often face mispronunciations or misunderstandings, particularly in university settings.
Modern universities are highly diverse environments, with students from various cultural and national backgrounds bringing different linguistic habits, cultural symbols, and naming conventions.
This diversity enriches academic and social exchanges, but it also introduces complexity and challenges in name pronunciation.
In such multicultural settings, both the individuals pronouncing names and those whose names are being pronounced often encounter challenges, sometimes resulting in unintentionally amusing mistakes.
This issue is especially prominent in countries like the United States, where names originally written in logographic #footnote[#link("https://en.wikipedia.org/wiki/Writing_system#Logographic_systems")[Wikipedia: Writing_system\#Logographic_systems]] systems (like Chinese) or alphabetical systems (like Arabic, Hindi, or Persian) can still be mispronounced, even when their spellings align perfectly with English phonotactics #footnote[#link("https://en.wikipedia.org/wiki/Phonotactics")[Wikipedia: Phonotactics]].

Although these moments can foster opportunities for cross-cultural understanding, they also highlight the complexities of navigating diversity in everyday communication.
While previous studies have extensively explored linguistic factors influencing name pronunciation, the role of appearance (e.g., ethnicity, clothing style, and perceived cultural background) in shaping assumptions about pronunciation has received little in-depth investigation.
One possible explanation for these mispronunciations is that when people meet someone in person, they may infer their race or cultural background based on appearance, which influences their perception of how the name should be pronounced.
English speakers often associate certain "stereotypical phonetic features" with different cultures, leading to shifts in pronunciation, even when the correct pronunciation is straightforward.

= Background

Such "stereotypical phonetical features" is not something new to English. Take the out-dated ethnic slur "Ching chong" as an example: According to _National Public Radio_, it is a derogatory imitation of Mandarin and Cantonese phonology @chow2014chingchong, due to the high-frequency occurrence of the retroflex fricatives (sounds like #phone[ʂ], #phone[ʐ] and such) and velar nasals (the #phone[ŋ] sound, usually spelled with the digraph #ortho[ng] in English).

Similar things have also happened on other languages, but as we're stepping into the current decade, a new form of these imitations are appearing—the language/accent imitating viral videos.
They could be found on almost every video platforms like YouTube @brianbeepboop2024fakechinese or TikTok @straightouttarussia2021fakerussian.

Also, a phenomenon called _hypercorrection_ #footnote[#link("https://en.wikipedia.org/wiki/Hypercorrection")[Wikipedia: Hypercorrection]] may happen when one encounters an unfamiliar language environment.
It is the nonstandard use of language that results from the overapplication of a perceived rule of language-usage prescription.
In our case, reading names of exotic cultures might trigger hypercorrection on English users.

= Related Work

This @barton2018social study demonstrates a "social" bouba/kiki effect, where people associate round names with round faces and angular names with angular faces, showing a preference for name-face congruence that influences social judgment and even practical outcomes like voting behavior.

This @baills2023embodying study reveals that less fluent names negatively impact job opportunities, particularly for candidates with weaker résumés, due to cognitive biases, contributing to labor market discrimination against ethnic and complex names.

@nemer1987phonological

- *Method*: The researcher references experimental acoustic data to illustrate how /k/ changes to /tʃ/. This includes analyzing changes in sound frequencies and airflow patterns, providing evidence for the physical and auditory factors contributing to these changes.
- *Conclusion*: Pronunciation biases often stem from a speaker's accent and perceptual habits, such as errors in speech production or constraints imposed by airflow dynamics. Misunderstandings in perception (e.g., confusion between similar sounds) can also drive sound changes, but these changes are typically directional rather than random.

@garrett2011phonetic

- *Method*: The study observes surnames, given names, nicknames, and school names (within the education system, potentially influenced by colonial history). It compares the localized phonological system of Temne names with the phonological features of foreign names.

- *Conclusion*: Names, as symbols of social identity and cultural recognition, hold particular significance in contexts of cultural interaction. Changes in the phonological features of names reflect the dynamic interplay between language, culture, and social values.

#let rq = body => {
	quote(block: true)[#text(size: 1.2em)[#body]]
}

= RQ \#1

#rq[Do American people have different phonological preferences when pronouncing names of different cultures?]

#columns(2)[

== Goal

In this research, we want to:

+ Find out if the above-said phonological shift in name pronunciation exists on American people.

+ If it does, portrait an outline of how the shifts are like on each culture.

== Method

To achieve the first goal, we will collect a set of phonologically ambiguous  names from cultures across the world, and display them along with faces of random culture.
For each time, only one name and one face is displayed.

We will sample randomly among local American people by asking for participation at different locations across the town.
We will ask them to guess the pronunciation of each name and record their pronunciation for later analysis.
Pronunciations with no face being displayed could work as a control group.

We will build a simple interactive game to help display the names and faces randomly, and also record audios of the pronunciations.

The collected voice clips will go through phonological analysis, from which we could extract key features of each pronunciation.
We will then apply quantitative methods on the extracted features to see if a certain culture is correlated to certain features.
The correlation could be furtherly discussed to answer the question in the second goal.

== Variables and Expectation

The independent variable is the cultures of the faces instead of the names;
and the dependent variable is the phonological features extracted from the voice clips.

It might be surprising that the independent variable is not the names, and the dependent variable is not the phonological shifts (how "off" they are to the correct pronunciation).
This is because we don't actually care about how names are mispronounced, but what we really care is the bias or tendency in phonology when people are facing faces of different cultures.

We expect to see that the cultures do be correlated to phonological features.

== Data Analysis

RQ1 uses a within-subject design to analyze changes in phonological tendencies, applying paired t-tests and correlation analysis.

#colbreak()

=== Data Collection and Tools

- Praat

	- Used to analyze audio recordings.
	- Extracts phonological features (e.g., pitch, vowel length, intensity).

- R Studio

	- Used for statistical analysis of phonological data extracted from Praat.

=== Tools and Methods

- Paired t-test

	- Purpose: Compare phonological features for the same participant across the two conditions (control vs. experimental).
	- Justification: Paired t-tests are suitable for within-subject data to analyze changes in phonological features between conditions.

- Correlation Analysis

	- Purpose: Explore the relationship between cultural features of faces and phonological features in pronunciation.
	- Justification: Correlation analysis can identify systematic biases in phonological tendencies influenced by cultural visual cues.

]

= RQ \#2

#rq[How does a person's appearance influence the way their name is pronounced?]

#columns(2)[

== Variables and Expectation

- *Independent Variable*: Whether the participant sees the person’s appearance.

- *Dependent Variable*: Accuracy of name pronunciation (rated on a scale from 0 to 100).

== Method

To address the first research objective, participants will be divided into two groups: a control group and an experimental group.
Each participant will engage in a task where they pronounce names under specific conditions.

This study adopts a _between-subject design_, where each participant will be exposed to only one condition:

+ Names presented without any associated face (control condition).

+ Names paired with faces of different cultural backgrounds (experimental condition).

Participants in the control group will be provided with only the written names, without any accompanying photos or visual cues.
They will be asked to pronounce each name based solely on the text, serving as a baseline to measure pronunciation accuracy without visual influences.

Participants in the experimental group will be shown written names paired with photographs of individuals from various ethnic and cultural backgrounds.
They will be asked to pronounce each name, with their pronunciation potentially influenced by visual cues such as ethnicity, clothing style, or perceived cultural origin.

An interactive system will be developed to facilitate random pairing of names and faces (for the experimental group) and display names alone (for the control group).
The system will also record participants’ audio pronunciations for subsequent analysis.

The recorded audio clips will undergo phonological analysis to extract key features of each pronunciation.
Quantitative methods will then be applied to these features to determine whether specific cultural representations influence pronunciation accuracy.

== Experiment Groups

=== Control Group

Participants in the control group will not see the person’s appearance.

*Procedure*:

+ Participants will be provided with only the written names (without accompanying photos or visual cues).
+ They will be asked to pronounce each name based solely on the text.

*Purpose*: To measure baseline pronunciation accuracy when visual appearance is not a factor.

=== Experimental Group

Participants in the experimental group will see the person’s appearance.

*Procedure*:

+ Participants will be shown written names alongside photographs of individuals representing various ethnic and cultural backgrounds.
+ They will be asked to pronounce each name, with their pronunciation potentially influenced by visual cues (e.g., ethnicity, clothing style, perceived cultural origin).

*Purpose*: To measure how the inclusion of visual appearance impacts the accuracy of name pronunciation.

== Goal

+ Compare the accuracy scores between the control group and the experimental group.
+ Assess whether seeing the person’s appearance significantly affects pronunciation accuracy, and explore variations based on cultural or linguistic background.

== Data Analysis

RQ \#2 uses a between-subject design to compare pronunciation accuracy differences, applying independent t-tests and ANOVA (if there are multiple cultural groups).

=== Data Collection and Tools 

+ Praat: Used to analyze audio recordings and evaluate pronunciation accuracy (e.g., how closely it matches the target pronunciation).
+ R Studio: Used for statistical analysis of accuracy data.

=== Data Analysis 

- Independent t-Test

	- Purpose: Compare the mean pronunciation accuracy between the control and experimental groups.
	- Justification: Independent t-tests are appropriate for analyzing differences in means between two independent groups.

- One-Way ANOVA (if the experimental group includes multiple cultural subgroups)

	- Purpose: Analyze whether cultural backgrounds significantly impact pronunciation accuracy.
	- Justification: ANOVA is suitable for comparing means across three or more groups.

]

#bibliography(
	"../bibliography.bib",
	full: true
);