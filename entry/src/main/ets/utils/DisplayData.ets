//解析xml判断横竖屏配置
import fs from '@ohos.file.fs';
import xml from '@ohos.xml';

let insideTarget: boolean = false;
const XML_PATH: string = '/system/etc/window/resources/display_manager_config.xml';

export class DisplayData {
  public static orientation: number = 0;
  public static parseBuildInDefaultOrientation(): number {
    console.error(`xhd parseBuildInDefaultOrientation`);
    try {
      console.error(`xhdd parseBuildInDefaultOrientation`);
      if (!fs.accessSync(XML_PATH)) {
        console.error(`xhd XML file not found: ${XML_PATH}`);
        return 0;
      }
      const xmlContent: string = fs.readTextSync(XML_PATH);

      let arrayBuffer: ArrayBuffer = new ArrayBuffer(xmlContent.length * 2);
      let bufView: Uint8Array = new Uint8Array(arrayBuffer);
      for (let i = 0; i < xmlContent.length; i++) {
        bufView[i] = xmlContent.charCodeAt(i);
      }

      let parser: xml.XmlPullParser = new xml.XmlPullParser(arrayBuffer);
      let callback = (key: xml.EventType, info: xml.ParseInfo): boolean => {
        if (key === xml.EventType.START_TAG && info.getName() === 'buildInDefaultOrientation') {
          insideTarget = true;
        } else if (key === xml.EventType.TEXT && insideTarget) {
          const text = info.getText().trim();
          console.info(`xhd Found buildInDefaultOrientation text = '${text}'`);
          DisplayData.orientation = parseInt(text);
        } else if (key === xml.EventType.END_TAG && info.getName() === 'buildInDefaultOrientation') {
          insideTarget = false;
          return false;
        }
        return true;
      };

      let options: xml.ParseOptions = {
        supportDoctype: true,
        ignoreNameSpace: true,
        tokenValueCallbackFunction: callback
      };

      parser.parse(options);
      return DisplayData.orientation;
    } catch (err) {
      console.error(`xhd parseBuildInDefaultOrientation failed: ${JSON.stringify(err)}`);
      return 0;
    }
  }
}
