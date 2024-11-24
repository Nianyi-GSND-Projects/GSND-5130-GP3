# 采访用小软件需求稿

## 要达成的目的

方便单人线下操作独自完成采访任务。
预定为静态网页，可以挂到 GitHub Pages 上那种。

## 要涵盖的功能

- 每次刷新页面都开启一次新的采访。

	- 采访未完成时关闭/刷新页面会拦一下，以防意外丢数据。

- 每次采访展示固定轮次的问答单元。

	- 每次问答从池子里随机挑选一个名字和一个人像，展示出来。
		- 最好能保证不重复，洗牌的说。
	- 一个主按钮，长按录音（不好做的话就一个开始一个结束）。
	- 录完之后可以选择重录或者跳过（这个不做也行）。
	- 也可以有个「提前结束」的按钮，以免采访对象突然离开也没法收集有效数据。

- 全部过完后，展示结束页面。

	- 「谢谢」信息。
	- 一些填元信息的表单字段（可不加）。
	- 「保存」按钮，给我们自己用的，按下之后会生成一个记录本次采访的数据包，可以导出（下载）到手机本地。

## 保存的数据格式

一个 JSON 文件，里面是对象，记录本次采访的信息，格式如下：

```ts
type Interview = {
	meta: {	// 元信息
		time: string; // 采访时间
		location: string;	// 采访地点，建议必填
		interviewer?: string; // 采访者
	};
	data: Array<DataEntry>; // 收集到的有效数据
}
```

数组的每个元素都是代表一次问答的对象。
对象格式：

```ts
type DataEntry = {
	name: string; // 展示的名字
	culture: string; // 展示的人像的文化
	portraitUrl: string; // 展示的人像的 URL
	/*
		为什么要有这个字段，是因为人像里有更多信息，我们不知道后面会不会用到。
		留一手，万一用到也可以恢复。
	*/
	voiceClip: string; // 录音音频的 Base64 编码
}
```

以下为示例文件（Base64 编码略去）：

```json
{
	"meta": {
		"time": "Sat Nov 23 2024 20:33:44 GMT-0500 (Eastern Standard Time)",
		"location": "Fenway",
		"interviewer": "Xuhong"
	},
	"data": [
			{
				"name": "Adal",
				"culture": "Middle Eastern",
				"portraitUrl": "https://github.com/Nianyi-GSND-Projects/GSND-5130-GP3/Interviewing%20Application/assets/portraits/iranian-female.jpg",
				"voiceClip": "..."
			},
			{
				"name": "Nate",
				"culture": "Japanese",
				"portraitUrl": "https://github.com/Nianyi-GSND-Projects/GSND-5130-GP3/Interviewing%20Application/assets/portraits/japanese-male.jpg",
				"voiceClip": "..."
			},
	]
}
```

## 大致的技术要点

- 录音

	- [MediaStream Recording API](https://developer.mozilla.org/en-US/docs/Web/API/MediaStream_Recording_API)

	- [MediaRecorder](https://developer.mozilla.org/en-US/docs/Web/API/MediaRecorder)

		用 `MediaRecorder.requestData()` 可以拿到录到的二进制数据，是个 `Blob` 对象。

- 数据打包

	- [FileReader: readAsDataURL()](https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL)

		这个方法能把 `Blob` 转成 Base64。

- 数据导出

	- [Blob: Blob() constructor](https://developer.mozilla.org/en-US/docs/Web/API/Blob/Blob)

		直接把 `JSON.stringify()` 过的字符串扔给它，创建一个新 `Blob`；
		然后调 `FileReader.readAsDataURL()` 获取其下载链接；
		最后按[这里](https://stackoverflow.com/a/49917066/15186859)的方法触发下载就可以了。

		记得给下载的文件名加个时间戳，以免意外覆盖。