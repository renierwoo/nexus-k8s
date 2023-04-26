#!/usr/bin/env python
from setuptools import setup, find_packages

install_requires = [
    'botocore==1.29.121',
    'docutils>=0.10,<0.17',
    's3transfer>=0.6.0,<0.7.0',
    'PyYAML>=3.10,<5.5',
    'colorama>=0.2.5,<0.4.5',
    'rsa>=3.1.2,<4.8',
]

setup_options = dict(
    name='awscli',
    version=find_version("awscli", "__init__.py"),
    description='Universal Command Line Environment for AWS.',
    long_description=read('README.rst'),
    author='Amazon Web Services',
    url='http://aws.amazon.com/cli/',
    scripts=['bin/aws', 'bin/aws.cmd',
             'bin/aws_completer', 'bin/aws_zsh_completer.sh',
             'bin/aws_bash_completer'],
    packages=find_packages(exclude=['tests*']),
    include_package_data=True,
    install_requires=install_requires,
    extras_require={},
    license="Apache License 2.0",
    python_requires=">= 3.7",
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Natural Language :: English',
        'License :: OSI Approved :: Apache Software License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
    ],
    project_urls={
        'Source': 'https://github.com/aws/aws-cli',
        'Reference': 'https://docs.aws.amazon.com/cli/latest/reference/',
        'Changelog': 'https://github.com/aws/aws-cli/blob/develop/CHANGELOG.rst',
    },
)

setup_options['console'] = ['bin/aws']

setup(**setup_options)
