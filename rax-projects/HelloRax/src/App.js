import {createElement, Component} from 'rax';
import View from 'rax-view';
import Text from 'rax-text';
import styles from './App.css';

class App extends Component {
  render() {
    return (
      <View style={styles.app}>
        {/* 第一个flex item */}
        <View style={styles.appHeader}>
          <Text style={styles.appBanner}>Hello Rax</Text>
        </View>

        {/* 第二个flex item */}
        <Text style={styles.appIntro}>
          To get started, edit src/App.js and save to reload.
        </Text>
      </View>
    );
  }
}

export default App;
