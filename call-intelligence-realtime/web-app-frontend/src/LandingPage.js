import React, { Component } from 'react';
import { Container } from 'reactstrap';
import './LandingPage.css';

export default class LandingPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      articles: [
        {
          id: 1,
          title: 'Getting Started with AI-Powered Analytics',
          excerpt: 'Learn how to leverage artificial intelligence for business process optimization...',
          date: '2024-01-15',
          link: '#'
        },
        {
          id: 2,
          title: 'Transforming Customer Service with Real-time Intelligence',
          excerpt: 'Discover the power of real-time conversation analytics in modern call centers...',
          date: '2024-01-10',
          link: '#'
        },
        {
          id: 3,
          title: 'Automation Best Practices for BPO',
          excerpt: 'Explore proven strategies for implementing workflow automation in your organization...',
          date: '2024-01-05',
          link: '#'
        }
      ]
    };
  }

  render() {
    return (
      <div className="landing-page">
        {/* Navigation Bar */}
        <nav className="navbar">
          <div className="nav-container">
            <h2 className="logo">BPO Intelligence</h2>
            <div className="nav-links">
              <a href="#about">About</a>
              <a href="#articles">Articles</a>
              <a href="#tools">Tools</a>
              <button className="btn-analytics" onClick={this.props.onNavigateToAnalytics}>
                Go to Call Analytics
              </button>
            </div>
          </div>
        </nav>

        {/* Hero Section */}
        <section className="hero-section">
          <Container>
            <div className="hero-content">
              <h1 className="hero-title">Welcome to My BPO Intelligence Hub</h1>
              <p className="hero-subtitle">
                Empowering businesses with AI-driven insights, automation, and intelligent analytics
              </p>
              <div className="hero-buttons">
                <button className="btn-primary" onClick={this.props.onNavigateToAnalytics}>
                  Explore Call Analytics
                </button>
                <button
                  className="btn-secondary"
                  onClick={() => window.open('https://your-n8n-instance.com', '_blank')}
                >
                  Open n8n Automation
                </button>
              </div>
            </div>
          </Container>
        </section>

        {/* About Section */}
        <section id="about" className="about-section">
          <Container>
            <div className="section-header">
              <h2>About Me</h2>
              <div className="divider"></div>
            </div>
            <div className="about-content">
              <div className="about-text">
                <p>
                  Welcome! I specialize in business process optimization and intelligent automation solutions.
                  With expertise in AI-powered analytics, real-time conversation intelligence, and workflow automation,
                  I help organizations transform their operations and deliver exceptional customer experiences.
                </p>
                <p>
                  This platform showcases my work in integrating cutting-edge technologies like Azure AI,
                  OpenAI GPT, and n8n automation to create powerful solutions for modern businesses.
                </p>
                <div className="skills">
                  <span className="skill-tag">AI & Machine Learning</span>
                  <span className="skill-tag">Process Automation</span>
                  <span className="skill-tag">Real-time Analytics</span>
                  <span className="skill-tag">Cloud Solutions</span>
                  <span className="skill-tag">Workflow Optimization</span>
                </div>
              </div>
            </div>
          </Container>
        </section>

        {/* Tools Section */}
        <section id="tools" className="tools-section">
          <Container>
            <div className="section-header">
              <h2>Available Tools</h2>
              <div className="divider"></div>
            </div>
            <div className="tools-grid">
              <div className="tool-card" onClick={this.props.onNavigateToAnalytics}>
                <div className="tool-icon">
                  <i className="fas fa-chart-line"></i>
                </div>
                <h3>Call Analytics</h3>
                <p>Real-time conversation intelligence with AI-powered transcription and insights extraction</p>
                <button className="tool-btn">Launch Tool</button>
              </div>

              <div
                className="tool-card"
                onClick={() => window.open('https://your-n8n-instance.com', '_blank')}
              >
                <div className="tool-icon">
                  <i className="fas fa-project-diagram"></i>
                </div>
                <h3>n8n Automation</h3>
                <p>Workflow automation platform for connecting apps and creating powerful integrations</p>
                <button className="tool-btn">Open n8n</button>
              </div>

              <div className="tool-card">
                <div className="tool-icon">
                  <i className="fas fa-database"></i>
                </div>
                <h3>Data Analytics</h3>
                <p>Post-call analytics with Power BI dashboards and Azure cognitive services</p>
                <button className="tool-btn">Coming Soon</button>
              </div>
            </div>
          </Container>
        </section>

        {/* Articles Section */}
        <section id="articles" className="articles-section">
          <Container>
            <div className="section-header">
              <h2>Latest Articles</h2>
              <div className="divider"></div>
              <p className="section-subtitle">Insights on AI, automation, and business intelligence</p>
            </div>
            <div className="articles-grid">
              {this.state.articles.map(article => (
                <div key={article.id} className="article-card">
                  <div className="article-date">{article.date}</div>
                  <h3 className="article-title">{article.title}</h3>
                  <p className="article-excerpt">{article.excerpt}</p>
                  <a href={article.link} className="article-link">
                    Read More <i className="fas fa-arrow-right"></i>
                  </a>
                </div>
              ))}
            </div>
          </Container>
        </section>

        {/* Footer */}
        <footer className="footer">
          <Container>
            <div className="footer-content">
              <div className="footer-section">
                <h4>BPO Intelligence</h4>
                <p>Transforming businesses through intelligent automation</p>
              </div>
              <div className="footer-section">
                <h4>Quick Links</h4>
                <a href="#about">About</a>
                <a href="#articles">Articles</a>
                <a href="#tools">Tools</a>
              </div>
              <div className="footer-section">
                <h4>Connect</h4>
                <div className="social-links">
                  <a href="#" className="social-link"><i className="fab fa-linkedin"></i></a>
                  <a href="#" className="social-link"><i className="fab fa-github"></i></a>
                  <a href="#" className="social-link"><i className="fab fa-twitter"></i></a>
                </div>
              </div>
            </div>
            <div className="footer-bottom">
              <p>&copy; 2024 BPO Intelligence. All rights reserved.</p>
            </div>
          </Container>
        </footer>
      </div>
    );
  }
}
